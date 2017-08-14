//
//  CryptorTools.m
//  加密/解密工具
//
//  Created by zhongyi on 15/4/26.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "CryptorTools.h"
#import <CommonCrypto/CommonCrypto.h>

#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
// 填充模式
#define kTypeOfWrapPadding		kSecPaddingPKCS1

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH  // SHA-1消息摘要的数据位数160位
@interface CryptorTools() {
    SecKeyRef _publicKeyRef;                             // 公钥引用
    SecKeyRef _privateKeyRef;                            // 私钥引用
}

@end
const uint8_t iv[8] = {1, 2, 3, 4, 5, 6, 7, 8};
//const Byte iv[] = {1,2,3,4,5,6,7,8};
@implementation CryptorTools

#pragma mark - DES 加密/解密
#pragma mark 加密
+ (NSData *)DESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmDES operation:kCCEncrypt keyString:keyString iv:iv];
}

+ (NSString *)DESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self DESEncryptData:data keyString:keyString iv:iv];
    
    // BASE 64 编码
    return [result base64EncodedStringWithOptions:0];
}

#pragma mark 解密
+ (NSData *)DESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmDES operation:kCCDecrypt keyString:keyString iv:iv];
}

+ (NSString *)DESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    // BASE 64 解码
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self DESDecryptData:data keyString:keyString iv:iv];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark - AES 加密/解密
#pragma mark 加密
+ (NSData *)AESEncryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmAES operation:kCCEncrypt keyString:keyString iv:iv];
}

+ (NSString *)AESEncryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self AESEncryptData:data keyString:keyString iv:iv];
    
    // BASE 64 编码
    return [result base64EncodedStringWithOptions:0];
}

#pragma mark 解密
+ (NSData *)AESDecryptData:(NSData *)data keyString:(NSString *)keyString iv:(NSData *)iv {
    return [self CCCryptData:data algorithm:kCCAlgorithmAES operation:kCCDecrypt keyString:keyString iv:iv];
}

+ (NSString *)AESDecryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv {
    // BASE 64 解码
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self AESDecryptData:data keyString:keyString iv:iv];
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark 对称加密&解密核心方法
///  对称加密&解密核心方法
///
///  @param data      加密/解密的二进制数据
///  @param algorithm 加密算法
///  @param operation 加密/解密操作
///  @param keyString 密钥字符串
///  @param iv        IV 向量
///
///  @return 加密/解密结果
+ (NSData *)CCCryptData:(NSData *)data algorithm:(CCAlgorithm)algorithm operation:(CCOperation)operation keyString:(NSString *)keyString iv:(NSData *)iv {
    
    int keySize = (algorithm == kCCAlgorithmAES) ? kCCKeySizeAES128 : kCCKeySizeDES;
    int blockSize = (algorithm == kCCAlgorithmAES) ? kCCBlockSizeAES128: kCCBlockSizeDES;
    
    // 设置密钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    
    // 设置 IV 向量
    uint8_t cIv[blockSize];
    bzero(cIv, blockSize);
    int option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    if (iv) {
        [iv getBytes:cIv length:blockSize];
        option = kCCOptionPKCS7Padding;
    }
    
    // 设置输出缓冲区
    size_t bufferSize = [data length] + blockSize;
    void *buffer = malloc(bufferSize);
    
    // 加密或解密
    size_t cryptorSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          algorithm,
                                          option,
                                          cKey,
                                          keySize,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &cryptorSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:cryptorSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 加密或解密失败 | 状态编码: %d", cryptStatus);
    }
    
    return result;
}

#pragma mark - RSA 加密/解密算法
- (void)loadPublicKeyWithFilePath:(NSString *)filePath; {
    
    NSAssert(filePath.length != 0, @"公钥路径为空");
    
    // 删除当前公钥
    if (_publicKeyRef) CFRelease(_publicKeyRef);
    
    // 从一个 DER 表示的证书创建一个证书对象
    NSData *certificateData = [NSData dataWithContentsOfFile:filePath];
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    NSAssert(certificateRef != NULL, @"公钥文件错误");
    
    // 返回一个默认 X509 策略的公钥对象，使用之后需要调用 CFRelease 释放
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    // 包含信任管理信息的结构体
    SecTrustRef trustRef;
    
    // 基于证书和策略创建一个信任管理对象
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    // 信任结果
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 评估之后返回公钥子证书
    _publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(_publicKeyRef != NULL, @"公钥创建失败");
    
    if (certificateRef) CFRelease(certificateRef);
    if (policyRef) CFRelease(policyRef);
    if (trustRef) CFRelease(trustRef);
}

- (void)loadPrivateKey:(NSString *)filePath password:(NSString *)password {
    
    NSAssert(filePath.length != 0, @"私钥路径为空");
    
    // 删除当前私钥
    if (_privateKeyRef) CFRelease(_privateKeyRef);
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // 从 PKCS #12 证书中提取标示和证书
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {passwordRef};
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    // 返回 PKCS #12 格式数据中的标示和证书
    OSStatus status = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    
    if (status == noErr) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        myIdentity = (SecIdentityRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        myTrust = (SecTrustRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
    }

    if (optionsDictionary) CFRelease(optionsDictionary);
    
    NSAssert(status == noErr, @"提取身份和信任失败");
    
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 提取私钥
    status = SecIdentityCopyPrivateKey(myIdentity, &_privateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
    CFRelease(items);
}

- (NSString *)RSAEncryptString:(NSString *)string {
    NSData *cipher = [self RSAEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [cipher base64EncodedStringWithOptions:0];
}

- (NSString *)RSAEncryptStringWithoutBase64:(NSString *)string{
    NSData *cipher = [self RSAEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", cipher);
    NSLog(@"cipher---%@", [[NSString alloc] initWithData:cipher encoding:NSUTF8StringEncoding]);
//    return [[NSString alloc] initWithData:cipher encoding:NSUTF8StringEncoding];
    return [cipher base64EncodedStringWithOptions:0];
}

- (NSData *)RSAEncryptData:(NSData *)data {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    
    NSAssert(data, @"明文数据为空");
    NSAssert(_publicKeyRef, @"公钥为空");
    
    NSData *cipher = nil;
    uint8_t *cipherBuffer = NULL;
    
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(_publicKeyRef);
    keyBufferSize = data.length;
    
    if (kTypeOfWrapPadding == kSecPaddingNone) {
        NSAssert(keyBufferSize <= cipherBufferSize, @"加密内容太大");
    } else {
        NSAssert(keyBufferSize <= (cipherBufferSize - 11), @"加密内容太大");
    }
    
    // 分配缓冲区
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0x0, cipherBufferSize);
    
    // 使用公钥加密
    sanityCheck = SecKeyEncrypt(_publicKeyRef,
                                kTypeOfWrapPadding,
                                (const uint8_t *)data.bytes,
                                keyBufferSize,
                                cipherBuffer,
                                &cipherBufferSize
                                );
    
    NSAssert(sanityCheck == noErr, @"加密错误，OSStatus == %d", (int)sanityCheck);
    
    // 生成密文数据
    cipher = [NSData dataWithBytes:(const void *)cipherBuffer length:(NSUInteger)cipherBufferSize];
    
    if (cipherBuffer) free(cipherBuffer);
    
    return cipher;
}

- (NSString *)RSADecryptString:(NSString *)string {
    NSData *keyData = [self RSADecryptData:[[NSData alloc] initWithBase64EncodedString:string options:0]];
    
    return [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
}

- (NSData *)RSADecryptData:(NSData *)data {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    
    NSData *key = nil;
    uint8_t *keyBuffer = NULL;
    
    SecKeyRef privateKey = _privateKeyRef;
    NSAssert(privateKey != NULL, @"私钥不存在");
    
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(privateKey);
    keyBufferSize = data.length;
    
    NSAssert(keyBufferSize <= cipherBufferSize, @"解密内容太大");
    
    // 分配缓冲区
    keyBuffer = malloc(keyBufferSize * sizeof(uint8_t));
    memset((void *)keyBuffer, 0x0, keyBufferSize);
    
    // 使用私钥解密
    sanityCheck = SecKeyDecrypt(privateKey,
                                kTypeOfWrapPadding,
                                (const uint8_t *)data.bytes,
                                cipherBufferSize,
                                keyBuffer,
                                &keyBufferSize
                                );
    
    NSAssert1(sanityCheck == noErr, @"解密错误，OSStatus == %d", sanityCheck);
    
    // 生成明文数据
    key = [NSData dataWithBytes:(const void *)keyBuffer length:(NSUInteger)keyBufferSize];
    
    if (keyBuffer) free(keyBuffer);
    
    return key;
}
+ (NSString *)encryptJson:(NSString *)jsonStr andKey:(NSString *)key {
//    return [self encryptUseDES:jsonStr andKey:key andIv:@"xxoo"];
    return [self hexStringFromString:[self encryptUseDES:jsonStr key:key]];
}
//+ (NSString *)encryptUseDES:(NSString *)plainText andKey:(NSString *)authKey andIv:(NSString *)authIv{
//    const void *iv  = (const void *) [authIv UTF8String];
//    NSString *ciphertext = nil;
//    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger dataLength = [textData length];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [authKey UTF8String],
//                                          kCCKeySizeDES,
//                                          iv,
//                                          [textData bytes],
//                                          dataLength,
//                                          buffer,
//                                          1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        NSString *oriStr = [NSString stringWithFormat:@"%@",data];
//        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
//        ciphertext = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
//    }
//    re

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key

{
    
    NSString *ciphertext = nil;
    
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [textData length];
    
    unsigned char buffer[1024];
    
    memset(buffer, 0, sizeof(char));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          
                                          [key UTF8String], kCCKeySizeDES,
                                          
                                          iv,
                                          
                                          [textData bytes], dataLength,
                                          
                                          buffer, 1024,
                                          
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
//        ciphertext = [Base64 encode:data];
        ciphertext = [data base64EncodedStringWithOptions:0];
        
    }
    
    return ciphertext;
    
}

#pragma mark- 解密算法

+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key

{
    
    NSString *plaintext = nil;
    
    // BASE 64 解码
    NSData *cipherdata = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    
    unsigned char buffer[1024];
    
    memset(buffer, 0, sizeof(char));
    
    size_t numBytesDecrypted = 0;
    
    // kCCOptionPKCS7Padding|kCCOptionECBMode 最主要在这步
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          
                                          [key UTF8String], kCCKeySizeDES,
                                          
                                          iv,
                                          
                                          [cipherdata bytes], [cipherdata length],
                                          
                                          buffer, 1024,
                                          
                                          &numBytesDecrypted);
    
    if(cryptStatus == kCCSuccess) {
        
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
        
    }
    
    return plaintext;
    
}
//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString; 
    
    
}
//普通字符串转换为十六进制的。

- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

- (NSString *)signMsg:(NSString *)jsonStr {
    return [self signTheDataSHA1WithRSA:jsonStr andPrivKey:@"123456"];
}


//私钥进行签名（SHA1withRSA）
- (NSData *)getHashBytes:(NSData *)plainText {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], (uint32_t)[plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}


-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText andPrivKey:(NSString *)privKey
{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"p" ofType:@"p12"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
    [options setObject:privKey forKey:(id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((CFDataRef) data, (CFDictionaryRef)options, &items);
    
    
    if (securityError!=noErr) {
        return nil ;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecKeyRef privateKeyRef=nil;
    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);
    
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self getHashBytes:plainTextBytes] bytes],
                                kChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    }
    else
    {
        return nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }
    NSString *signatureResult=[NSString stringWithFormat:@"%@",[signedHash base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    return [self hexStringFromString:signatureResult]; // 转换成 HEX字符串
//    return signatureResult;
}
//4）	使用接收方公钥对会话密钥SK加密（RSA/ECB/PKCS1Padding），并将结果转换为HEX字符串，得到key_enc域。

- (NSString *)encryptKey:(NSString *)key {
    return  [self hexStringFromString:[self RSAEncryptStringWithoutBase64:key]];
}
@end

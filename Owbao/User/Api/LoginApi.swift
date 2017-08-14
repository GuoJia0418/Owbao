//
//  LoginAPi.swift
//  Owbao
//
//  Created by mac on 16/2/29.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class LoginApi: BaseApi {
    var mobilephone: String?
    var passWord: String?
    var picCode: String?       //图形验证码
    
    init(mobilephone: String, passWord: String, PicCode:String) {
        super.init()
        self.mobilephone = mobilephone
        self.passWord = passWord
        self.picCode = PicCode
    }
    override func requestUrl() -> String! {
        return LOGIN_API
    }
    override func untreatedArgument() -> Any! {
//        let dict = ["mobilephone": mobilephone!,"passWord": passWord!]
//        print(dict)
//        var jsonStr: NSString = ""
//        do {
//            let data =  try NSJSONSerialization.dataWithJSONObject(dict, options: [] )
//            jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)!
//        } catch let error as NSError  {
//            
//            print(error.localizedDescription)
//        }
//        // Do any additional setup after loading the view, typically from a nib.
//        let tool = CryptorTools()
//        // 加载公钥
//        let pubPath = NSBundle.mainBundle().pathForResource("rsacert.der", ofType: nil)
//        print(pubPath)
//        tool.loadPublicKeyWithFilePath(pubPath!)
//
//        // 生成 key
//        //         1）	对请求或响应json报文明文（UTF-8编码）使用发送方的私钥进行签名（SHA1withRSA），并将签名结果转换为HEX字符串，得到sign域。
////        let jsonStr = "{'name':'yan'}"
//        print(jsonStr as String)
//        let mac = tool.signMsg(jsonStr as String)
//        print("mac---"+mac)
//        //         2）	使用KeyGenerator生成器，生成DES加密会话密钥SK；
////        let des_keyc = "A20504A20D34EA8CA8EC268687D7CD8217BA1B7332016B4F197112E37249C4C32FE21F039A715E7FB2A124168E59E764C17665C32F23D367" // 随机生产 字符串
//        //
////        uint8_t iv[8] = {1, 2, 3, 4, 5, 6, 7, 8};
////        NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
////
////        NSString *result1 = [CryptorTools AESEncryptString:str keyString:key iv:ivData];
////        let des_keyc = [CryptorTools AESEncryptString:"11" keyString:key iv:ivData];
//        //3）	使用SK对json明文进行加密（DES/CBC/PKCS5Padding），并将加密结果转换为HEX字符串，得到json_enc域。
//        let des_keyc = "11"
//        let json_enc = CryptorTools.encryptJson(jsonStr as String, andKey: des_keyc)
//        print("json_enc--"+json_enc);
//        //        4）	使用接收方公钥对会话密钥SK加密（RSA/ECB/PKCS1Padding），并将结果转换为HEX字符串，得到key_enc域。
//        let key_enc = tool.encryptKey(des_keyc)
//        print("key_enc--"+key_enc);
//        print("-----------------------------")
//        print("key 16禁止变字符串--"+CryptorTools.stringFromHexString(key_enc))
//        //        print("key 解密---"+ CryptorTools.RSADecryptString(<#T##CryptorTools#>))
//        // 加载私钥
//        let privatePath = NSBundle.mainBundle().pathForResource("p.p12", ofType: nil)
//        tool.loadPrivateKey(privatePath, password: "123456")
//        print("解密之后---"+tool.RSADecryptString(CryptorTools.stringFromHexString(key_enc)))
//        let params = ["json_enc":json_enc, "key_enc": key_enc, "sign": mac]
//        print("--------------------------------------------")
//        return  ["passWord": "123456", "mobilephone": "fdfdfdff"]
        
        if picCode != nil && picCode != ""
        {
            return ["passWord": passWord!, "mobilephone": mobilephone!,"picCode":picCode!]
        }
        else
        {
            return ["passWord": passWord!, "mobilephone": mobilephone!]
        }
        
    }
}

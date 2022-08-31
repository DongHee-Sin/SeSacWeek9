//
//  LottoAPIManager.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/08/30.
//

import Foundation


/*
 
 URLSession.shared
    - 단순한 네트워크 작업 / 커스텀 불가 / 응답은 클로저로 받음
    - 백그라운드 통신 불가
 
 default configuration (URLSession.init(configuration:))
    - shared과 설정 유사 / 응답은 클로저 + Delegate
    - 커스텀 가능 (셀룰러 연결 여부, 타임 아웃 간격)
        타임아웃: 일정시간 이상 response가 오지 않으면, 얼럿같은걸로 사용자에게 알려주기 위한...
*/



enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}



class LottoAPIManager {
    
    static func requestLotto(drwNo: Int, completion: @escaping (Lotto?, APIError?) -> Void) {
       
        let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)")!        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Reailed Request")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No Data Returned")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable Response")
                    completion(nil, .invalidResponse)
                    return
                }

                guard response.statusCode == 200 else {
                    print("Failed Response")
                    completion(nil, .failedRequest)
                    return
                }
                
                
                do {
                    let result = try JSONDecoder().decode(Lotto.self, from: data)
                    print(result.drwNoDate)
                    completion(result, nil)
                }
                catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
            
        }.resume()
        
    }
    
}

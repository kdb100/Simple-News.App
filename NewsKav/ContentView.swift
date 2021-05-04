//
//  ContentView.swift
//  NewsKav
//
//  Created by KDB on 2021-05-02.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct ContentView: View {
    
    @ObservedObject var list = getData()
    var body: some View {
        NavigationView{
            List(list.datas){i in
                NavigationLink(destination:
                                webView(url: i.url)
                                .navigationBarTitle("", displayMode: .inline)){
                    HStack(spacing: 15){
                        VStack(alignment: .leading, spacing: 10){
                            Text(i.title).fontWeight(.heavy)
                            Text(i.desc).lineLimit(2)
                        }
                        
                        if i.image != ""{
                            WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                                .resizable()
                                .frame(width: 110, height: 110)
                                .cornerRadius(15)
                            
                        }
                        
                    } .padding(.vertical, 15)
                    
                }
                
            }.navigationBarTitle("Headlines")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct dataType : Identifiable {
    var id : String
    var title : String
    var desc : String
    var url : String
    var image : String
    
    
}

class getData : ObservableObject{
    @Published var datas = [dataType]()
    
    init(){
        let source =         "https://newsapi.org/v2/top-headlines?country=sa&apiKey=f283fbf47ca440348bbfcbae6c7a8e50"
     
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
            }
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, title: title, desc: description, url: url, image: image ))
                }
                
            }
        }.resume()
    }
}

struct webView :  UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: UIViewRepresentableContext<webView>) ->
    WKWebView{
        
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>){
        
    }
}
// generate an API key in news API
// African Countries limited to South Africa(za) & Nigeria(ng) - Tech Crunch
//Categories limited to business entertainment general health science sports technology

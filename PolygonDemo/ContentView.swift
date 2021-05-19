//
//  ContentView.swift
//  PolygonDemo
//
//  Created by 靖漆 on 2021/5/10.
//

import SwiftUI

/// Description
/// Backview to get touch points
struct BackView : View {
    var body: some View {
        ZStack {
            Color.blue
        }
    }
}

/// Description
/// Draw polygon on backview using drawPoints
struct DrawView : View {
    var drawPoints : [CGPoint] = []
    var body: some View {
        Path { path in
            if drawPoints.count > 0 && !drawPoints.contains((CGPoint(x: 0, y: 0))){
                path.move(to: CGPoint(x: drawPoints.first!.x, y: drawPoints.first!.y))
                drawPoints.forEach { point in
                    path.addLine(to: CGPoint(x: point.x, y: point.y))
                }
            }
        }.stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

/// Description
/// Buttons overlay drawview overlay backview
struct ContentView: View {
    @State var drawPoints : [CGPoint] = [CGPoint(x: 0, y: 0)]
    @State private var showResetWarning = false
    @State private var showNotFinishWarning = false
    @State private var doneBtnTapped = false
    var body: some View {
        
        BackView()
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                    }
                    .onEnded { value in
                        if value.location.x > 0 && value.location.y > 0{
                            if drawPoints.contains(CGPoint(x: 0, y: 0)) {
                                //remove init CGPoint which is 0,0
                                drawPoints.removeFirst()
                            }
                            //after tap done button should clear canvas
                            if doneBtnTapped {
                                drawPoints .removeAll()
                                doneBtnTapped.toggle()
                            }
                            //insert new touch point to points array
                            drawPoints.insert(value.location, at: drawPoints.count)
                        }
                    }
            )
            .overlay(
                DrawView(drawPoints: drawPoints)
                    .overlay(
                        HStack {
                            Spacer()
                            VStack (alignment: .trailing,spacing:20) {
                                Spacer()
                                Button(action: {
                                    if drawPoints.count > 2 {
                                        //add first point to points array to complete polygon
                                        drawPoints.insert(drawPoints.first!, at: drawPoints.count)
                                        doneBtnTapped.toggle()
                                    }   else {
                                        showNotFinishWarning.toggle()
                                    }
                                    
                                }, label: {
                                    Text("Done")
                                        .font(.system(size: 30))
                                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 60)
                                        .padding(.trailing, 15)
                                })
                                
                                .alert(isPresented: $showNotFinishWarning) {
                                    Alert(title: Text("Warning"), message: Text("There should be more than 2 vertexs to finish polygon"), dismissButton: .default(Text("Got it!")))
                                }
                                Button(action: {
                                    if drawPoints.count > 0 {
                                        //remove all points to clear canvas
                                        drawPoints.removeAll()
                                    } else {
                                        showResetWarning.toggle()
                                    }
                                }, label: {
                                    Text("Reset")
                                        .font(.system(size: 30))
                                        .foregroundColor(.red)
                                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 60)
                                        .padding(.trailing, 15)
                                })
                                .alert(isPresented: $showResetWarning) {
                                    Alert(title: Text("Warning"), message: Text("There is no polygon to clear"), dismissButton: .default(Text("Got it!")))
                                }
                            }
                        })
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

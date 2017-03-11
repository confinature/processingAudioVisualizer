// Minimモジュール
import ddf.minim.analysis.*;
import ddf.minim.*;

//インスタント変数など
Minim minim;//Minim
AudioInput in;//オーディオの入力
FFT fft;//高速フーリエ変換
int BUFSIZE = 512;//FFtが利用するメモリサイズ

int R=100;//真ん中の円の半径

//setup
void setup(){
  //windowサイズ
  size(800,800);
  
  //Minimの初期化
  minim=new Minim(this);
  
  //ステレオミュージック入力の取得(BUFSIZE=512)
  in = minim.getLineIn(Minim.STEREO, BUFSIZE);
  
  //↑をFFTと関連付ける
  fft=new FFT(in.bufferSize(),in.sampleRate());
  
  //カラーモードをHSBに
  colorMode(HSB,360,100,100,100);
  
  //線は描画しない
  noStroke();
  
  //frameRate(40);
}

int ang=0;//真ん中の円で使う
void draw(){
  fill(0,0,100,100);//100%で塗りつぶす(白)
  noStroke();
  rect(0,0,width,height);//塗りつぶす四角(windowいっぱい)
  
  // FFT 実行（左右混合）
  fft.forward(in.mix);
  // FFTのスペクトラムの幅を変数に保管
  float specSize = fft.specSize();
  
  
  //下で使う変数の宣言
  float low=0;
  float mid=0;
  float high=0;

  //各円を動かす
  for(int j=0;j<=85;j++)
    low+=fft.getBand(j);
  float lowSound=low/85;
  fill(107, 71, 91, 100);
  ellipse(width/2, height/2, lowSound*300+550, lowSound*300+550);
      
  for(int j=85;j<170;j++)
    mid+=fft.getBand(j);
  float midSound=mid/85;
  fill(209, 100, 92, 100);
  ellipse(width/2, height/2, midSound*500+400, midSound*500+400);
  
  for(int j=170;j<specSize;j++)
    high+=fft.getBand(j);
  float highSound=high/85;
  fill(330, 64, 92, 100);
  ellipse(width/2, height/2, highSound*200+250, highSound*200+250);
  
  //真ん中の円
  fill(360);
  ellipse(width/2, height/2, 50, 50);
  
  //回るやつ
  float rad=radians(ang);
  stroke(0);
  strokeWeight(4);
  line(width/2, height/2, width/2+25*cos(rad),height/2+25*sin(rad));
  ang+=1;
}


// プログラム終了時の処理を定めます
void stop()
{
  minim.stop();
  super.stop();
}
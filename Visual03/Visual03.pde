//http://processingnyumon.blog.jp/archives/3331282.html
//↑をminim対応させただけです。

// Minim を使用する準備
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;

// オーディオ入力の変数
AudioInput in;
// FFTの変数
FFT fft;
// FFT が利用するメモリサイズ
int BUFSIZE = 512;

float yoff = 0.0;  

void setup() {  
    // windowサイズを指定
  size(600, 400);

  // Minim を初期化
  minim = new Minim(this);

  // ステレオオーディオ入力を取得します
  in = minim.getLineIn(Minim.STEREO, BUFSIZE);

  // ステレオオーディオ入力を FFT と関連づけます
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  // カラーモードを HSB に指定
  //colorMode(HSB, 360, 100, 100, 100);
  
  noStroke();
}

void draw() {
  //背景色
  background(247,152,152);

  fill(255);
  beginShape(); 
  // FFT 実行（左右混合）
  fft.forward(in.mix);
  //スペクトラムの幅を変数に収納
  int specSize = fft.specSize(); //specSize=257
  
  for (int i = 0; i < specSize; i++)
  {
    // 線を描く x を、スペクトラム幅に応じた位置として取得します
    float size = map(fft.getBand(i), 0, 500, 0, 100);
    float x=map(i,0,specSize,0,width+450);
    
    // fft.getBnad 
    //line(x, height, x, height - fft.getBand(i) * 12);
    
    if(x>=width+20)
      break;
    vertex(x, height - size * 320 -100); 
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}
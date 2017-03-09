// Minim を使用する準備です
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;

// オーディオ入力の変数を用意します
AudioInput in;

// FFTの変数を用意します
FFT fft;

// FFT が利用するメモリサイズを定めます
int BUFSIZE = 512;

// プログラム開始時の事前準備です
void setup()
{
  // キャンバスサイズを指定します
  size(600, 600);

  // Minim を初期化します
  minim = new Minim(this);

  // ステレオオーディオ入力を取得します
  in = minim.getLineIn(Minim.STEREO, BUFSIZE);

  // ステレオオーディオ入力を FFT と関連づけます
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  // カラーモードを HSB に指定します
  colorMode(HSB, 360, 100, 100, 100);
  
  // 線を描画しません
  noStroke();
}

// 描画内容を定めます
void draw()
{
  // 背景色を 10% の黒で塗りつぶします
  // 前フレームの内容が薄く残ります
  fill(311, 100, 100, 50);
  rect(0, 0, width, height);

  // FFT 実行（左チャンネル）
  fft.forward(in.left);
  
  // FFTのスペクトラムの幅を変数に保管します
  float specSize = fft.specSize();

  // スペクトラムに応じて円を描画します
  for (int i = 0; i < specSize; i++)
  {
    float h = map(i, 0, specSize, 0, 100);
    float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width/2);
    float x = map(i, 0, fft.specSize(), width/2, 0);
    fill(311, h, 100, 70);
    ellipse(x, height/2, ellipseSize*20, ellipseSize*20);
  }

  // FFT 実行（右チャンネル）
  fft.forward(in.right);

  // FFTのスペクトラムの幅を変数に保管します
  specSize = fft.specSize();

  // スペクトラムに応じて円を描画します
  for (int i = 0; i < specSize; i++)
  {
    float h = map(i, 0, specSize, 0, 100);
    float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width/2);
    float x = map(i, 0, specSize, width/2, width);
    fill(311, h, 100, 70);
    ellipse(x, height/2, ellipseSize*20, ellipseSize*20);
  }
}

// プログラム終了時の処理を定めます
void stop()
{
  minim.stop();
  super.stop();
}
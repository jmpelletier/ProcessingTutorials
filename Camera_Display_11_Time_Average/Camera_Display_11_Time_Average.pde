/**
 * このスケッチでは、カメラの映像の
 * 時間軸上の「移動平均」を計算する。
 * 動いている物はぼやけて見えて、静止すると
 * くっきりと見える。
 */

import processing.video.*;

Capture cam; // カメラ
PImage cameraImage; // カメラの画像を保存する画像
PImage outImage; // 出力の画像

// 画像の平均を計算するが、綺麗に表示するために、
// 高精度のデータが必要。「double」とは、64ビットの
// 高精度の小数点数。
double[][] averageColors;

int cameraNumber = 0; // 使うカメラのインデックス（順番）

// 以下のパラメータで効果の強弱を調整する
// alphaが0に近いほど強くなる
double alpha = 0.01; // 移動平均の値（0～1）

float fps = 30; // カメラのフレームレート

// プログラムの初期設定
void setup() {

  // ウィンドウのサイズを設定
  size(640, 480);

  // カメラの画像を保存する画像を作成する
  cameraImage = createImage(width, height, RGB);

  // 出力の画像を作成する
  outImage = createImage(width, height, RGB);
  
  averageColors = new double[cameraImage.width * cameraImage.height][];
  for (int i = 0; i < averageColors.length; i++) {
    averageColors[i] = new double[]{0, 0, 0}; 
  }

  // カメラのリスト（配列）を取得する
  String[] cameras = Capture.list();

  // カメラが接続されているかを確認する
  if (cameras.length == 0) {
    // 接続されていないようで、エラーを出力する
    println("There are no cameras available for capture.");
    // プログラムを修了する
    exit();
  } else { // カメラが見つかった...

    // 見つけたカメラの名称を出力する
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // 指定したカメラのインデックスが大きすぎないかを確認する
    if (cameraNumber < cameras.length && cameraNumber >= 0) {
      // カメラを起動させる
      cam = new Capture(this, cameras[cameraNumber], fps);
      cam.start();
    } else { // カメラのインデックスが大きすぎる
      // エラーを出力して修了する
      println("Invalid index");
      exit();
    }
  }
}

// フレームの描写
void draw() {
  // カメラの準備はできているか？
  if (cam.available() == true) {
    // カメラの映像を更新する
    cam.read();

    // カメラの映像を画像にコピーする
    cameraImage.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);

    // 以下の指示を実行しないと画像のピクセルを操作する事ができない
    cameraImage.loadPixels();
    outImage.loadPixels();

    // 二重ループを使って、取り込んだ画像のピクセルを一つずつ処理する
    for (int y = 0; y < cameraImage.height; y++) {
      for (int x = 0; x < cameraImage.width; x++) {
        // 「何番目」かのピクセルを操作するか、xとy座標から計算する
        int i = y * cameraImage.width + x;
        int j = y * cameraImage.width + x;
        
        // カメラのピクセルからRGBの値を取得する
        double r = red(cameraImage.pixels[i]);
        double g = green(cameraImage.pixels[i]);
        double b = blue(cameraImage.pixels[i]);
        
        // RGB別に移動平均を計算する
        // 計算自体は補間と同じ式になる
        averageColors[j][0] = r * alpha + averageColors[j][0] * (1.0 - alpha);
        averageColors[j][1] = g * alpha + averageColors[j][1] * (1.0 - alpha);
        averageColors[j][2] = b * alpha + averageColors[j][2] * (1.0 - alpha);

        // 平均のピクセルを出力の画像にコピーする
        outImage.pixels[j] = color((float)averageColors[j][0], (float)averageColors[j][1], (float)averageColors[j][2]);
      }
    }

    // 画像のピクセルが更新されたら、最後に以下の指示を実行して、確定させる。
    outImage.updatePixels();
  }

  // 画像を表示する
  image(outImage, 0, 0);
}

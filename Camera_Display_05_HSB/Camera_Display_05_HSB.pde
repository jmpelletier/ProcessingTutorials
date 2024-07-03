/**
 * このスケッチでは、入力の画像のピクセルからHSB形式の
 * 色を取得する。このデータから新しい「色」を生成して、
 * 出力画像のピクセルの色にする。
 */

import processing.video.*;

Capture cam; // カメラ
PImage cameraImage; // カメラの画像を保存する画像
PImage outImage; // 出力の画像

int cameraNumber = 0; // 使うカメラのインデックス（順番）

float fps = 30; // カメラのフレームレート

// プログラムの初期設定
void setup() {

  // ウィンドウのサイズを設定
  size(640, 480);

  // 色空間をHSBにする
  // HSBの値は色相（H）が0～360、彩度（S）と明度（B）がが0～100
  colorMode(HSB, 360, 100, 100);

  // カメラの画像を保存する画像を作成する
  cameraImage = createImage(width, height, RGB);

  // 出力の画像を作成する
  outImage = createImage(width, height, RGB);

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

        // カメラのピクセルからHSBの値を取得する。
        float h = hue(cameraImage.pixels[i]);
        float s = saturation(cameraImage.pixels[i]);
        float b = brightness(cameraImage.pixels[i]);

        // HSBの値から新しい色を生成して、出力の画像のピクセルの色にする。
        outImage.pixels[j] = color(h, s, b);
      }
    }

    // 画像のピクセルが更新されたら、最後に以下の指示を実行して、確定させる。
    outImage.updatePixels();
  }

  // 画像を表示する
  image(outImage, 0, 0);
}

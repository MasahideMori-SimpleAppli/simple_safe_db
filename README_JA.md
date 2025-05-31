# simple_safe_db

## 注意
このプロジェクトは作成中です。この注意書きが消えるまでは利用できません。

## 概要
「SimpleSafeDB」は、フロントエンド用のインメモリデータベースです。  
このデータベースではクラス構造をそのままデータベースに登録でき、登録したクラスの要素を型安全に検索できます。  

本パッケージにはインデックス作成などの検索高速化手法は取り入れられておらず、メモリ上を直接検索します。  
このため、大規模データでの利用や検索速度が求められる場合には、一般的なデータベースの利用を推奨します。  

## 使い方
作成中です。  

## サポート
基本的にサポートはありません。
もし問題がある場合はGithubのissueを開いてください。
このパッケージは優先度が低いですが、修正される可能性があります。

## バージョン管理について
それぞれ、Cの部分が変更されます。  
ただし、バージョン1.0.0未満は以下のルールに関係無くファイル構造が変化する場合があります。  
- 変数の追加など、以前のファイルの読み込み時に問題が起こったり、ファイルの構造が変わるような変更
  - C.X.X
- メソッドの追加など
  - X.C.X
- 軽微な変更やバグ修正
  - X.X.C

## ライセンス
このソフトウェアはApache-2.0ライセンスの元配布されます。LICENSEファイルの内容をご覧ください。  

Copyright 2025 Masahide Mori

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.  

## 著作権表示
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.
# chef 11系


## chef-serverとchef-soloの違い
chef-serverだとchef-soloと比べて以下のような機能が使える。
* node一覧の取得や管理
* recipe一覧
* run_listの管理
* data bagの登録と検索

## chef-server
* インストール
Opscode Omnibus Packagingを利用するのが楽。
centosならrpmとかを入れる感じ。


## chef-workstation
* インストール
vagrantなどにセットアップすると楽。
インストールはOpscode Omnibus Packagingのインストールスクリプトを使うのが楽。


## chef-client
* インストール
同様にOpscode Omnibus Packagingのインストールスクリプトを使うか、
knife bootstrapを使用する。



## ohai
chefのattributeで指定するパラメータの一覧を表示できる。
chefと一緒にインストールされる。
* 一覧
ohai
* 変数確認
ohai <value>
※ohai platform
* chefからの値の参照
chefからは node[:platform] という形で参照する。
※ohaiではなくchefのattributeは node['nginx']['port'] という参照の仕方。


## berkshelf
複数のcookbookを管理する。
cookbookがgemだとすると、berkshelfはbundlerみたいなもの。
* インストール

```
cd <chef-repo>
vi Gemfile
--
source :rubygems
gem 'berkshelf'
--
bundle --path vendor/bundle
echo "vendor" >> .gitignore
```
* 使い方

```
cd <chef-repo>
vi Berksfile
--
site :opscode
cookbook 'yum'
cookbook 'nginx'
--
bundle exec berks --path <cookbook-dir>
```
* vagrantとの連携

```
berks cookbook <cookbook-name>
cd <cookbook-name>
bundle
vi Berksfile
--
site :opscode

metadata
cookbook 'yum'
cookbook 'nginx'
</code></pre>
--
```
あとはVagrantfileに普段nodeで定義するような適用recipeのJSONを記載する。
bundle exec vagrant up
※すでに仮想マシン作成済みでchefのみ適用したい場合は「bundle exec vagrant provision」。


## knifeコマンド
* ノード情報の検索

```
knife search node <pattern>
```
※platromがcentos「knife search node "platform:cents"」
※FQDNがnodeで始まる「knife search node "fqdn:node*"」
※centosでruby 1.8系「knife search node "platform:centos AND languages_ruby_version:1.8*"」
* 複数ノードでコマンド実行

```
knife ssh node <pattern> <command>
```
※FQDNがnodeで始まるnodeでuptime「knife ssh node "fqdn:node*" "uptime"」
※centosでchef-client「knife ssh node "platform:centos" "sudo chef-client"」
* chef-clientの作成

```
knife bootstrap <node-ip-address> [-x vagrant] --sudo -N <node-name>
```
※chefのインストール、/etc/chefディレクトリの作成、chef-validator用の鍵コピーと設置、chef-clientの設定ファイルclient.rbの設定、chef-clientを実行してchef-serverに登録、をまとめてしてくれる。
※これでchef-clientをインストールしたら、以降chef-client実行時に「--server」や「-N」オプションが不要になる。


## chef-clientやchef-soloの実行方法
* knifeコマンド

```
echo <user1>@<node1> <user2>@<node2> | xargs -n 1 knife solo cook
```
* knifeによるsshコマンド実行

```
knife ssh node <pattern> "sudo chef-client"
```
* capistranoなどのデプロイツールを使用
* psshやスクリプトなどによる複数リモートログインでの実行



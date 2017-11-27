module Ruboty
  module Handlers
    class Marjang < Base
      on(
        /start/, # botが反応する言葉の条件（正規表現が利用可能）
        name: 'start', # 呼び出すメソッド名
        description: 'start to play mahjang' # help message で表示される discription
      )

      on(
        /[0-9]|1[0-3]/,
        name: 'discard',
        description: 'discard tile'
      )

      # ゲーム開始（初期化）
      def start(message)
        # 全136牌の定義
      	@tiles = [	0,0,0,0,
      							1,1,1,1,
      							2,2,2,2,
      							3,3,3,3,
      							4,5,5,5,
      							6,6,6,6,
      							7,7,7,7,
      							8,8,8,8,
      							9,9,9,9,
      							10,10,10,10,
      							11,11,11,11,
      							12,12,12,12,
      							13,13,13,13,
      							14,15,15,15,
      							16,16,16,16,
      							17,17,17,17,
      							18,18,18,18,
      							19,19,19,19,
      							20,20,20,20,
      							21,22,21,21,
      							22,22,22,22,
      							23,23,23,23,
      							24,25,25,25,
      							26,26,26,26,
      							27,27,27,27,
      							28,28,28,28,
      							29,29,29,29,
      							30,30,30,30,
      							31,32,31,31,
      							32,32,32,32,
      							33,33,33,33,
                    34,34,34,34,
                    35,35,35,35,
                    36,36,36,36
      					]

        # 置換emojiの定義
      	@trans_set =[	":1w:",
	      							":2w:",
	      							":3w:",
	      							":4w:",
                      ":a5w:",
                      ":5w:",
	      							":6w:",
	      							":7w:",
	      							":8w:",
	      							":9w:",
	      							":1s:",
	      							":2s:",
	      							":3s:",
	      							":4s:",
                      ":a5s:",
                      ":5s:",
	      							":6s:",
	      							":7s:",
	      							":8s:",
	      							":9s:",
	      							":1p:",
	      							":2p:",
	      							":3p:",
	      							":4p:",
                      ":a5p:",
                      ":5p:",
	      							":6p:",
	      							":7p:",
	      							":8p:",
	      							":9p:",
	      							":ton:",
	      							":nan:",
	      							":sha:",
	      							":pe:",
	      							":haku:",
	      							":hatsu:",
	      							":chun:"
      						]
      	@mytiles = []

        # 初期配牌
      	for i in 1..13 do
      		drawn = rand(@tiles.length) # まだ引かれていない牌（山）の中から牌を選ぶ
      		@mytiles << @tiles[drawn] # 手牌に引いた牌を加える
      		@tiles.slice!(drawn) # 引かれた牌を山から取り除く
      	end
      	draw(message)
      end

      # 牌を引く
      def draw(message)
      	mytiles_str = ""
      	@mytiles.sort!
      	drawn = rand(@tiles.length)
      	@mytiles << @tiles[drawn]
      	@tiles.slice!(drawn)
      	@mytiles.each {|tile| mytiles_str += @trans_set[tile] }

        message.reply("Your tiles:")
        message.reply(mytiles_str)
        message.reply(":index_0::index_1::index_2::index_3::index_4::index_5::index_6::index_7::index_8::index_9::index_10::index_11::index_12::index_13:")
        message.reply("Please select a tile to discard index number. Like `mj 0`, `mj 1`.")
      	message.reply("Left tiles number: " + @tiles.length.to_s)
      end

      # 牌を切る
      def discard(message)
        # 選択した牌を捨てる
      	message.reply(@trans_set[@mytiles.slice!(message.body.to_s.split(" ")[1].to_i)])
        if @tiles.length >= 0
          draw(message)
        else
          draw("Tiles aren't left. Game over.")
        end
      end
    end
  end
end

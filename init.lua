-- =================================================================
-- 🛠️ クラフトレシピメーカー & コードジェネレーター (多言語完全対応版)
-- =================================================================

recipe_maker = {}

-- Luanti標準の翻訳システム（i18n）を初期化
local S = core.get_translator("recipe_maker")

-- 1. 専用の画面（Formspec）を動的に生成する関数
local function get_recipe_maker_formspec(pos, output_code)
	-- 翻訳テキストのキーを最も安全な1行の文字列にロック
	if not output_code then
		output_code = "【" .. S("Usage") .. "】\n" ..
		              "1. " .. S("Place ingredients into the 3x3 grid on the left.") .. "\n" ..
		              "2. " .. S("Place the outcome into the single slot on the right.") .. "\n" ..
		              "3. " .. S("Click the [Generate Code] button.")
	end
	output_code = core.formspec_escape(output_code)

	-- ★【噂通りの完全修正】実用に耐える最高安定バージョンの「5」を明示指定！
	local formspec = "formspec_version[5]" ..
		"size[11,10.0]" ..
		
		-- スロットサイズは極小「0.6」、隙間 0.1
		"style_type[list;size=0.6,0.6;spacing=0.1,0.1]" ..
		
		-- 【仕様5準拠】box命令の区切りをカンマ「,」に統一して完全固定
		-- これにより、背景座布団が絶対にズレずにクッキリ描画されます
		"box[0.4,0.7;2.2,2.2;#202020aa]" ..
		"box[3.4,1.5;0.8,0.8;#202020aa]" ..
		
		-- 【1】素材入力枠 (3x3)
		"label[0.5,0.4;" .. S("Materials (3x3)") .. "]" ..
		"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";craft_input;0.5,0.8;3,3;]" ..
		
		-- 【2】完成品枠
		"label[3.5,1.2;" .. S("Outcome") .. "]" ..
		"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";craft_output;3.5,1.6;1,1;]" ..
		
		-- 【3】コード生成ボタン
		"button[5.0,1.6;2.5,0.8;generate_code;" .. S("Generate Code") .. "]" ..
		
		-- 【4】出力テキストエリア
		"label[0.5,3.8;" .. S("Generated Lua Code / JSON Array") .. "]" ..
		"textarea[0.5,4.3;10.0,2.2;code_box;;" .. output_code .. "]" ..
		
		-- 【5】プレイヤーインベントリ
		"box[0.4,7.5;5.7,2.2;#202020aa]" ..
		"label[0.5,7.2;" .. S("Inventory") .. "]" ..
		"list[current_player;main;0.5,7.6;8,3;]" ..
		"listring[nodemeta:"..pos.x..","..pos.y..","..pos.z..";craft_input]" ..
		"listring[current_player;main]"
		
	return formspec
end

-- 2. ブロック（ノード）の登録
core.register_node("recipe_maker:generator", {
	description = "クラフトレシピメーカー (Code Generator)",
	tiles = {"recipe_maker_block.png"}, 
	groups = {choppy = 2, oddly_breakable_by_hand = 2, creative_breakable = 1},
	light_source = 5,
	
	on_construct = function(pos)
		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("craft_input", 9)
		inv:set_size("craft_output", 1)
		meta:set_string("formspec", get_recipe_maker_formspec(pos))
	end,
	
	on_receive_fields = function(pos, formname, fields, player)
		if fields.generate_code then
			local meta = core.get_meta(pos)
			local inv = meta:get_inventory()
			
			local output_stack = inv:get_stack("craft_output", 1)
			local output_name = output_stack:get_name()
			local output_count = output_stack:get_count()
			
			-- 空の状態で押された場合はエラーメッセージを出し、それ以降の処理を絶対に実行させない安全ガード
			if not output_name or output_name == "" then
				meta:set_string("formspec", get_recipe_maker_formspec(pos, S("[Error] Please place the outcome item into the slot on the right!")))
				return
			end
			
			local items = {}
			for i = 1, 9 do
				local name = inv:get_stack("craft_input", i):get_name()
				items[i] = name
			end
			
			local lua_code = "core.register_craft({\n" ..
				"\toutput = \"" .. output_name .. " " .. output_count .. "\",\n" ..
				"\trecipe = {\n" ..
				"\t\t{\"" .. items[1] .. "\", \"" .. items[2] .. "\", \"" .. items[3] .. "\"},\n" ..
				"\t\t{\"" .. items[4] .. "\", \"" .. items[5] .. "\", \"" .. items[6] .. "\"},\n" ..
				"\t\t{\"" .. items[7] .. "\", \"" .. items[8] .. "\", \"" .. items[9] .. "\"}\n" ..
				"\t}\n" ..
				"})"
				
			local json_code = "\n\n--- JSON用配列フォーマット ---\n" ..
				"\"recipe\": [\n" ..
				"  [\"" .. items[1] .. "\", \"" .. items[2] .. "\", \"" .. items[3] .. "\"],\n" ..
				"  [\"" .. items[4] .. "\", \"" .. items[5] .. "\", \"" .. items[6] .. "\"],\n" ..
				"  [\"" .. items[7] .. "\", \"" .. items[8] .. "\", \"" .. items[9] .. "\"]\n" ..
				"]"

			meta:set_string("formspec", get_recipe_maker_formspec(pos, lua_code .. json_code))
		end
	end,
	
	on_dig = function(pos, node, digger)
		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		
		for i = 1, 9 do
			local stack = inv:get_stack("craft_input", i)
			if not stack:is_empty() then
				core.add_item(pos, stack)
			end
		end
		
		local out_stack = inv:get_stack("craft_output", 1)
		if not out_stack:is_empty() then
			core.add_item(pos, out_stack)
		end
		
		return core.node_dig(pos, node, digger)
	end,
})

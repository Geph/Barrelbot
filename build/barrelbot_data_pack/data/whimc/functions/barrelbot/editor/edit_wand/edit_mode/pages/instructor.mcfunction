data modify storage whimc:storage Page set value {Buttons: [], Text: []}
data modify storage whimc:storage Page.key set value "instructor"
data modify storage whimc:storage Page.Text append value {data: {transformation: {translation: [0.0f, 0.5f, 0.1f], scale: [1.0f, 1.0f, 1.0f]}}, text_provider: '{"text":"Instructor","color":"aqua"}'}
data modify storage whimc:storage Page.Buttons append value {item: {id: "minecraft:white_stained_glass_pane", tag: {CustomModelData: 130036}}, x_min: -150, x_max: 150, y_min: -400, y_max: -100, command: "function whimc:barrelbot/editor/edit_wand/edit_mode/pages/get_linked_puzzle", hover_text: "Get Linked Puzzle"}
data modify storage whimc:storage Page.Buttons append value {item: {id: "minecraft:white_stained_glass_pane", tag: {CustomModelData: 130005}}, x_min: -125, x_max: 125, y_min: -775, y_max: -525, command: "function whimc:barrelbot/editor/edit_wand/edit_mode/pages/close", hover_text: "Exit Menu"}

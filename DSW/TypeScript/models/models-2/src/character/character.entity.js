"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Character = void 0;
var node_crypto_1 = require("node:crypto");
var Character = /** @class */ (function () {
    function Character(name, characterClass, level, hp, mana, attack, items, id) {
        if (id === void 0) { id = node_crypto_1.default.randomUUID(); }
        this.name = name;
        this.characterClass = characterClass;
        this.level = level;
        this.hp = hp;
        this.mana = mana;
        this.attack = attack;
        this.items = items;
        this.id = id;
    }
    return Character;
}());
exports.Character = Character;

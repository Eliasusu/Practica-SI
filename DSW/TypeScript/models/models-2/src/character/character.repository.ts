import { Character } from "./character.entity.js";
import { Repository } from "../shared/repository.js";

const characters = [
  new Character(
    'Darth Vader',
    'Sith',
    10,
    100,
    20,
    10,
    ['Lightsaber', 'Death Star'],
    'a02b91bc-3769-4221-beb1-d7a3aeba7dad'
  ),
]


export class CharacterRepository implements Repository<Character>{
    public findAll(): Character[] {
        return characters;
    }
    public findById(item: {id: string}): Character | undefined {
        return characters.find((character) => character.id === item.id)
    }
    public add(item: Character): Character | undefined {
        characters.push(item)
        return item
    }
    public update(item: Character): Character | undefined {
        const id = characters.findIndex((character) => character.id === item.id)
        if(id !== -1){
            characters[id] = {...characters[id], ...item}
            return item
        }
        return characters[id];
    }
    public delete(item: {id: string}): Character | undefined {
        const id = characters.findIndex((character) => character.id === item.id)
        if(id !== -1){
            const character = characters[id]
            characters.splice(id, 1)
            return character
        }
        return characters[id];
    }
}
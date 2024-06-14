import { generateUid } from '../common/uid.ts';

export class Client{
    public id: string;
    constructor(public name: string, public adress: string, public phone: string){
        this.id = generateUid();
    }
}
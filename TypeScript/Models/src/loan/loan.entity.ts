import { Client } from '../client/client.entity.ts';
import { generateUid } from '../common/uid.ts';

export class Loan {
    public id: string;
    constructor(
        public deed: number, 
        public interestRate: number, 
        public deadLine: Date,
        public loanDate: Date,
        public client: Client,) {
            
        this.id = generateUid();

    }
}
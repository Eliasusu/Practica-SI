import { generateUid } from '../common/uid.ts';
import { Client } from '../client/client.entity.ts';
import { Loan } from './loan.entity.ts';

export class Payment {
    public id: string;

    constructor( 
        public paymentDate: Date,
        public isVoluntary: boolean,
        public client: Client,
        public loan: Loan,
        pays: {amount: number, loan: Loan}[],
        public goon?: string,
    ) {
        this.id = generateUid();
    }
}
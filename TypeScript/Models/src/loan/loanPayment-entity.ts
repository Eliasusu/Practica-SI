import { generateUid } from "../common/uid";
import { Loan } from "./loan.entity";
import { Payment } from "./payment.entity";

export class LoanPayment {
    public id: string;
    constructor(
        public payment: Payment,
        public loan: Loan,
        public amount: number,
        public paymentDate: Date,
    ){}
}
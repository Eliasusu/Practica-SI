// Purpose: Contains the LoanPayment entity class.
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
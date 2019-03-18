export class Task {
    public Id: number;
    public Title: string;
    public Completed: boolean;
    public CreatedDate: Date;
    public ModifiedDate: Date;

    // hàm khởi tạo
    constructor(title: string) {
        this.Title = title;
        this.Completed = false;
    }
}

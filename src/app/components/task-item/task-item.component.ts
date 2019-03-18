import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Task } from 'src/app/models/task.class';
import { FormControl } from '@angular/forms';

@Component({
  selector: 'app-task-item',
  templateUrl: './task-item.component.html',
  styleUrls: ['./task-item.component.scss']
})
export class TaskItemComponent implements OnInit {
  // có đang ở mode sửa
  isEditting = false;
  // nhận dữ liệu đổ ra giao diện
  @Input() task: Task;
  // truyền output ra, để nhận diện task nào bị thay đổi
  @Output() chooseItem = new EventEmitter<any>();
  // truyền id item cần xóa
  @Output() deleteItem = new EventEmitter<Task>();
  // sửa dữ liệu
  @Output() taskEdited = new EventEmitter<Task>();
  constructor() { }
  // form
  formEdit = new FormControl('');
  ngOnInit() {
  }

  // hàm thay đổi status của item
  changeStatus(e) {
    this.chooseItem.emit();
  }
  // mở form sửa
  onEdit() {
    this.isEditting = true;
  }
  // đóng form sửa
  cancelEdit() {
    this.isEditting = false;
  }
  // submit form sửa
  onSubmitEdit(data, e) {
    e.preventDefault();
    this.task.Title = data;
    this.taskEdited.emit(this.task);
    // đóng form sửa
    this.isEditting = false;
  }
  // handle xóa
  fireDelete(e) {
    this.deleteItem.emit(this.task);
  }
}

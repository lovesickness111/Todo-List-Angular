import { Component, OnInit, Output, EventEmitter, ViewChild, ElementRef } from '@angular/core';
import { Task } from 'src/app/models/task.class';

@Component({
  selector: 'app-task-form',
  templateUrl: './task-form.component.html',
  styleUrls: ['./task-form.component.scss']
})
export class TaskFormComponent implements OnInit {
  // tạo output để emit sự kiện ra component cha  kiểu truyền vào là 1 object
  @Output() addTask = new EventEmitter<Task>();
  constructor() { }
  // thao tác đối tượng input
  @ViewChild('title') title: ElementRef;
  ngOnInit() {
  }
  /**
   * xử lý thêm task sau đó làm trống input
   *value: giá trị truyền từ template
   *e : event submit form
   */
  submitForm(value, e) {
    e.preventDefault();
    this.addTask.emit(value);
    this.title.nativeElement.value = '';
  }
}

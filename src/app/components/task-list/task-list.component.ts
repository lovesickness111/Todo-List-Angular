import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Task } from 'src/app/models/task.class';
declare const $: any;
@Component({
  selector: 'app-task-list',
  templateUrl: './task-list.component.html',
  styleUrls: ['./task-list.component.scss']
})
export class TaskListComponent implements OnInit {
  // nhận giá trị từ cha
  @Input() tasks: Task[];
  // output task ra ngoài để update trạng thái
  @Output() getTaskId = new EventEmitter<Task>();
  // output id ra để xóa
  @Output() deleteTask = new EventEmitter<Task>();
  // sửa
  @Output() taskEdited = new EventEmitter<Task>();

  @Output() showType = new EventEmitter<number>();
  constructor() { }

  ngOnInit() {
  }
  // thay đổi trạng thái dựa vào id
  updateStatus(task) {
    this.getTaskId.emit(task);
  }
  // switch type
  changeType(e){
    e.preventDefault();
    $(e.target).closest('.task-filters').find('.item-task-type').removeClass('active');
    $(e.target).addClass('active');
  }
}

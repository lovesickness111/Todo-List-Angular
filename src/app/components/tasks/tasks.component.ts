import { Component, OnInit, OnDestroy } from '@angular/core';
import { TaskService } from 'src/app/services/task.service';
import { Task } from 'src/app/models/task.class';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-tasks',
  templateUrl: './tasks.component.html',
  styleUrls: ['./tasks.component.scss']
})
export class TasksComponent implements OnInit, OnDestroy {
  // mảng task
  public task: Task[] = [];
  public taskFilted: Task[];
  // xử lý asyn
  public subscription: Subscription;
  // điều kiện lọc, mặc định là lấy hết, 0 là chưa thực hiện, 1 là đã thực hiện
  taskType = 2;
  constructor(private taskService: TaskService) { }

  ngOnInit() {
    this.subscription = this.taskService.getAll().subscribe((tasks: Task[]) => {
      this.task = tasks;
      this.taskFilted = tasks;
    });
    console.log(this.task);
  }
  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
  // lọc task
  switchType(taskType) {
    switch (taskType) {
      case 0: {
        this.taskFilted = this.task.filter((t) => {
          return t.Completed === false;
        });
        break;
      }
      case 1: {
        this.taskFilted = this.task.filter((t) => {
          return t.Completed === true;
        });
        break;
      }
      default: {
        this.taskFilted = this.task;
        break;
      }
    }
  }
  // thêm task
  addTask(title: string) {
    const id = this.generateID() + 1;
    const task = new Task(title);
    task.Id = id;
    this.subscription = this.taskService.add(task).subscribe((data: any) => {
      this.task.push(task);
    });
  }
  // sửa trạng thái
  updateStatus(task: Task) {
    // đổi lại giao diện
    task.Completed = !task.Completed;
    // update database
    this.taskService.updateStatus(task.Id, task.Completed).subscribe((data) => {
      // hiện thông báo tại đây
    });
  }
  // xóa task
  deleteTask(task: Task) {
    // update db
    this.taskService.delete(task).subscribe((data) => {
      // cập nhật lại giao diện
      this.updateAfterDelete(task.Id);
    });
  }
  // hàm chạy đồng bộ sau khi xóa task thì cập nhật giao diện
  updateTemplate(data: Task) {
    for (let i = 0; i < this.task.length; i++) {
      if (this.task[i].Id === data.Id) {
        this.task[i] = data;
        break;
      }
    }
  }
  // update sau delete
  updateAfterDelete(id: number) {
    for (let i = 0; i < this.task.length; i++) {
      if (this.task[i].Id === id) {
        this.task.splice(i, 1);
        break;
      }
    }
  }
  // hàm sửa tên task dựa vào id task
  updateTask(t) {
    // update data
    this.taskService.update(t).subscribe((data) => {
      // success
    });
  }
  // hàm tìm id của bản ghi mới
  // 0 => các object trong mảng
  // tìm max của 1 mảng map ra từ task
  generateID(): number {
    return Math.max.apply(Math, this.task.map(o => o.Id));
  }
}

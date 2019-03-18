using Models.Dictionary;
using Services.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Repository.Base;
using Repository.Dictionary;
using Models;
namespace Services.Dictionary
{
    /// <summary>
    /// tạo class triển khai các phương thức của service-> gọi đến Tầng repository để thao tác DB
    /// </summary>
    public class TaskService : EntityService<TaskJob>, ITaskService
    {
        ITaskRepository _taskRepository;
        /// <summary>
        /// hàm khởi tạo class và đối tượng tham chiếu đến repository
        /// </summary>
        /// <param name="taskGroupRepository">dùng lại phương thức khởi tạo của class cha EntirySevice<T></param>
        public TaskService(ITaskRepository taskRepository) : base(taskRepository)
        {
            _taskRepository = taskRepository;
        }

        public int DeleteTask(TaskJob task)
        {
            return _taskRepository.Delete("dbo.Proc_DeleteTaskJobByID", new object[] { task.Id});
        }

        public int ChangeStatus(bool status, long ID)
        {
            return _taskRepository.ChangeStatus(status, ID);
        }
    }
}
using Models;
using Services.Common;
using System;
using System.Collections.Generic;
using System.Linq;



namespace Services.Dictionary
{
    public interface ITaskService : IEntityService<TaskJob>
    {
        int DeleteTask(TaskJob task);
        int ChangeStatus(bool status, long ID);
    }
}

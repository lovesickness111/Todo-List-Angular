using Models;
using Repository.Base;

namespace Repository.Dictionary
{
    /// <summary>
    /// tạo interface chứa hàm xử lý các nghiệp vụ tại tầng repo
    /// </summary>
    public interface ITaskRepository : IBaseRepository<TaskJob>
    {
        int ChangeStatus(bool status, long ID);
    }
}

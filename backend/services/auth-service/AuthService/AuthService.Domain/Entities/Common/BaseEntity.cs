namespace AuthService.Domain.Entities.Common;

public abstract class BaseEntity
{
    public Guid Id { get; protected set; }
    public DateTime CreatedAt { get; protected set; }
    public DateTime? UpdatedAt { get; protected set; }
    public bool IsDeleted { get; protected set; }
    
    protected BaseEntity()
    {
        CreatedAt = DateTime.UtcNow;
        IsDeleted = false;
    }
    
    public void SoftDelete() => IsDeleted = true;
    public void MarkUpdated() => UpdatedAt = DateTime.UtcNow;
}
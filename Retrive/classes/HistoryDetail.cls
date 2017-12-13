/**
 * @author mistry, rakesh - 'inspire'
 * @date 2011-09-27
 * ----------------
 * Contains the fields that represent a History record or every object
 * whose history tracing is enabled.
 *
 * Every object whose history tracking is enabled creates an object as -
 * <object>__History. This object contains records with fields - 'objectName,
 * parentId, Field, CreatedById, CreatedDate, IsDeleted, NewValue, Id and 
 * OldValue'. HistoryDetail creates a class to hold these variables.
 *
 * Other methods are just setters and getters for the fields.
 */
public class HistoryDetail {
    private String objectName, parentId, Field, CreatedById, CreatedDate, IsDeleted, NewValue, Id, OldValue, userName;

    public String getObjectName() {
        return objectName;
    }
    
    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getField() {
        return Field;
    }

    public void setField(String field) {
        this.Field = field;
    }

    public String getCreatedById() {
        return CreatedById;
    }

    public void setCreatedById(String createdById) {
        this.CreatedById = createdById;
    }

    public String getCreatedDate() {
        return CreatedDate;
    }

    public void setCreatedDate(String createdDate) {
        this.CreatedDate = createdDate;
    }

    public String getIsDeleted() {
        return IsDeleted;
    }

    public void setIsDeleted(String isDeleted) {
        this.IsDeleted = isDeleted;
    }

    public String getNewValue() {
        return NewValue;
    }

    public void setNewValue(String newValue) {
        this.NewValue = newValue;
    }

    public String getId() {
        return Id;
    }

    public void setId(String id) {
        this.Id = id;
    }

    public String getOldValue() {
        return OldValue;
    }

    public void setOldValue(String oldValue) {
        this.OldValue = oldValue;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
# Base Table System

نظام موحد لبناء الجداول في التطبيق. يوفر مكونات قابلة لإعادة الاستخدام لجميع أنواع الخلايا.

## المكونات الأساسية

### 1. BaseTableWidget
الجدول الأساسي الذي يعرض البيانات.

```dart
BaseTableWidget<YourModel>(
  columns: columns,
  data: dataList,
  showCheckbox: true,
  selectedRows: selectedItems,
  onRowSelect: (item, isSelected) {},
  config: BaseTableConfig.defaultConfig,
)
```

### 2. BaseTableColumn
يحدد عمود في الجدول.

```dart
BaseTableColumn<YourModel>(
  headerKey: 'translation.key',
  width: 120,
  cellBuilder: (item, index) => BaseTableCellFactory.text(text: item.name),
)
```

### 3. BaseTableCellFactory
مصنع لإنشاء أنواع مختلفة من الخلايا:

#### نص بسيط
```dart
BaseTableCellFactory.text(
  text: item.name,
  placeholder: '-',
)
```

#### نص قابل للتعديل
```dart
BaseTableCellFactory.editable(
  value: item.name,
  hint: 'translation.key',
  onChanged: (value) => updateItem(item, value),
  isNumeric: false,
)
```

#### Dropdown
```dart
BaseTableCellFactory.dropdown<String>(
  value: item.status,
  items: ['PENDING', 'ACCEPTED', 'COMPLETE'],
  onChanged: (value) => updateStatus(item, value),
  displayText: (item) => item,
)
```

#### Status Badge
```dart
BaseTableCellFactory.status(
  status: item.status,
  color: Colors.green,
)
```

#### رقم قابل للتعديل
```dart
BaseTableCellFactory.number(
  value: item.quantity,
  onChanged: (value) => updateQuantity(item, value),
)
```

## أمثلة الاستخدام

### جدول بسيط
```dart
final columns = [
  BaseTableColumn<Model>(
    headerKey: 'common.name',
    width: 200,
    cellBuilder: (item, index) => BaseTableCellFactory.text(text: item.name),
  ),
];
```

### جدول قابل للتعديل
```dart
final columns = [
  BaseTableColumn<Model>(
    headerKey: 'common.name',
    width: 200,
    cellBuilder: (item, index) => BaseTableCellFactory.editable(
      value: item.name,
      onChanged: (value) => onEdit(item, {'name': value}),
    ),
  ),
];
```

## التكوينات المتاحة

- `BaseTableConfig.defaultConfig` - للجداول العادية
- `BaseTableConfig.editableConfig` - للجداول القابلة للتعديل




/// Протокол Фабрики запросов
/// Новые запросы добавляются через протоколы
protocol DataRequestFactory: ExampleRequestFactory {}

/// Фабрика запросов
/// Все запросы добавляются через расширения для BaseDataRequestFactory
/// в файлах с конкретными запросами
class AppDataRequestFactory: DataRequestFactory {}

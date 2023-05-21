import UIKit

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
func GenerateString (lenOfString:Int)-> String{
    let Probability = lenOfString
    if Probability > 8 {
        return ""
    }else{
        return randomString(length: lenOfString)
    }
}
// НОВОЕ - Сделала функцию, которая генерирует номера
func GenerateNumber (Probability: Int) -> Int?{ //Здесь ? стоит, потому что возвращаемое значение может быть пустым
    if Probability > 8 {
        return nil
    } else {
        return Int.random(in: 1...100)
    }
}
//НОВОЕ - Добавила проверку на уже пустые поля и добавление запятой
func AddComma(field: String) -> String{
    guard field != "" else{
        return field
    }
    var newField = field + ", "
    return newField
}
// ПОЧТИ НОВОЕ - Функции генерации вынесла за пределы класса
struct Address {
    let city, streetName: String
    let buldingNumber, floor, apartment: Int? // Заменила на инт опционалы, потому что они могут принимать значение nil
}
class Person {
    let id: Int
    let firstName, lastName: String
    let age: Int? // Заменила на инт опционалы
    let address: Address
    init (id: Int, firstName: String, lastName: String, age: Int?, address: Address){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.address = address
    }
}
class Generator {
    let amountOfPerson: Int
    init (amountOfPerson:Int){
        self.amountOfPerson = amountOfPerson
    }
    func GeneratePersonality (){
        var persons = [Person]()
        for i in 0...amountOfPerson-1{
            let generatedAddress = Address (city: GenerateString(lenOfString: Int.random(in: 1...10)),streetName: GenerateString(lenOfString: Int.random(in: 1...10)), buldingNumber: GenerateNumber(Probability: Int.random(in: 1...10)), floor:GenerateNumber(Probability: Int.random(in: 1...10)),apartment: GenerateNumber(Probability: Int.random(in: 1...10)))
            
            let newPerson = Person(id: i, firstName: GenerateString(lenOfString: Int.random(in: 1...10)), lastName: GenerateString(lenOfString: Int.random(in: 1...10)), age: GenerateNumber(Probability: Int.random(in: 1...10)), address: generatedAddress)
            
            persons.append(newPerson)
        }
        Pathfinder.findAndWriteUnfullPerson(findPersons:persons)
    }
}
class Pathfinder{
    // НОВОЕ - избавилась от словаря и перешла на массив
    static func findAndWriteUnfullPerson (findPersons:[Person]) {
        enum SearchForEmptyFild{ // НОВОЕ - добавила перечесление, чтобы воспользоваться фильтром
            case filterByAllProperty(person:[Person])
            func filter() -> [Person]{
                switch self {
                case .filterByAllProperty(let person):
                    return person.filter{$0.firstName == "" || $0.lastName == "" || $0.age == nil || $0.address.city == "" || $0.address.streetName == "" || $0.address.buldingNumber == nil || $0.address.floor == nil || $0.address.apartment == nil}
                } // Фильтр добавляет объект в новый массив (в котором только объекты - коллеки), если хотя бы одного его свойство имеет пустое значение
            }
        }
        // Ниже тот самый массив
        var pureEmptyMassive = SearchForEmptyFild.filterByAllProperty(person: findPersons).filter()
        var fields = ""
        for i in pureEmptyMassive {
            // Я хотела через  enum как-нибудь красиво вывод сделать, но у меня не хватило время на поиски, чтобы до конца довести, поэтому вывод через иф сделала -><-
            if i.firstName == ""{
                fields = "Имя"
            }
            if i.lastName == ""{
                fields = AddComma(field:fields)
                fields += "Фамилия"
            }
            if i.age == nil{
                fields = AddComma(field: fields)
                fields += "Возраст"
            }
            if i.address.city == ""{
                fields = AddComma(field: fields)
                fields += "Город"
            }
            if i.address.streetName == ""{
                fields = AddComma(field: fields)
                fields += "Улица"
            }
            if i.address.buldingNumber == nil{
                fields = AddComma(field: fields)
                fields += "Номер дома"
            }
            if i.address.floor == nil{
                fields = AddComma(field: fields)
                fields += "Этаж"
            }
            if i.address.apartment == nil{
                fields = AddComma(field: fields)
                fields += "Квартира"
            }
            print("Экземпляр ",i.id,"Имеет пустые поля: ", fields)
            fields = ""
        }
        //for i in pureEmptyMassive{ // ЭТО Здесь для само проверки
        // print(i.id, "Name ", i.firstName," LastName: ", i.lastName," Age: ", i.age ?? "empty"," City: ", i.address.city,"Street", i.address.streetName," Building: ", i.address.buldingNumber ?? " empty ","floor",  i.address.floor ?? "empty","Apartment", i.address.apartment ?? "empty")
        //  }
        if pureEmptyMassive.isEmpty{
            print("Все экземпляры класса имеют заполненные поля")
        }
    }
}
var amountOfPerson = Generator(amountOfPerson: 10)
amountOfPerson.GeneratePersonality()



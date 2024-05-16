import UIKit



// MARK: - SRP(Single Responsibility Principle) - 단일 책임 원칙
// : 클래스나 함수를 설계할 때, 각 단위들은 단 하나의 책임만을 가져야한다는 원칙

struct Product {
    let price: Double
}

// 단일 책임 원칙을 위반 하고 있음
struct Invoice {
    var products: [Product]
    let id = NSUUID().uuidString
    var discountPercentage: Double = 0
    
    // 가격 계산
    var total: Double {
        let total = products.map({$0.price}).reduce(0, { $0 + $1 })
        let discountedAmount = total * (discountPercentage / 100)
        return total - discountedAmount
    }
    

    // 송장 인쇄
    func printInvoice() {
        let printer = InvoicePrinter(invoice: self)
        printer.printInvoice()
    }
    
    // 송장 저장
    func saveInvoice() {
        let persistence = InvoicePersistence(invoice: self)
        persistence.saveInvoice()
    }
    
}

struct InvoicePrinter {
    let invoice: Invoice
    
    // 송장 인쇄
    func printInvoice() {
        print("------------------")
        print("Invoice id: \(invoice.id)")
        print("Total cost $\(invoice.total)")
        print("Discounts: \(invoice.discountPercentage)")
        print("-----------------")
    }
}

struct InvoicePersistence{
    let invoice: Invoice
    
    func saveInvoice(){
        
    }
}

let products: [Product] = [
    .init(price: 99.99),
    .init(price: 9.99),
    .init(price: 24.99)
]

let invoice = Invoice(products: products, discountPercentage: 20)
//let printer = InvoicePrinter(invoice: invoice)
//let persistence = InvoicePersistence(invoice: invoice)
invoice.printInvoice()


let invoice2 = Invoice(products: products, discountPercentage: 20)
//let printer2 = InvoicePrinter(invoice: invoice2)
//let persistence2 = InvoicePersistence(invoice: invoice2)
invoice2.printInvoice()





// MARK: - Open/Closed Principle : OCP(Open-Closed Principle) - 개방, 폐쇄 원칙
// : 확장에는 열려있으나 변경에는 닫혀있어야 한다는 원칙입니다.

/*
 Swift가 정수, 문자열 또는 double과 같이 우리에게 제공하는 특정 값이나 데이터 유형에 대한 확장을 통해 기능을 추가 할 수 있는데 정수 데이터 유형을 직접 수정 할 수 없기 때문에 개방형 폐쇄 원칙 또는 OCP를 준수하여 구현 할 수 있습니다.
 */

//extension Int {
//    func squared() -> Int {
//        return self * self
//    }
//}
//
//var num = 2
//num.squared()

// 구조를 추상적으로 만들고 이 개방형 폐쇄 원칙을 준수하여 기능을 추가하고 있음 이는
// 이 프로토콜을 사용하여 별도의 구조를 생상하고 간단히 확장하므로 이는 SRP와 OCP 조합과 같음
struct InvoicePersistenceOCP {
    let persistence: InvoicePersistable
    
    func save(invoice: Invoice) {
        persistence.save(invoice: invoice)
    }
}

protocol InvoicePersistable {
    func save(invoice: Invoice)
}

struct CoreDataPersistence: InvoicePersistable{
    func save(invoice: Invoice) {
        print("Save invoice to CoreData \(invoice.id)")
    }
}

struct DatabasePersistence: InvoicePersistable{
    func save(invoice: Invoice) {
        print("Save invoice to Firestore \(invoice.id)")
    }
}

let coreDataPersistence = CoreDataPersistence()
let databasePersistence = DatabasePersistence()
let persistenceOCP = InvoicePersistenceOCP(persistence: coreDataPersistence)

persistenceOCP.save(invoice: invoice)



// MARK: - Liskov Substitution Principle (LSP) : LSP(Liskov Substitution Principle) - 리스코프 치환 원칙
// 부모(super class)로 동작하는 곳에서 자식(sub class)를 넣어주어도 대체가 가능해야한다는 원칙

// 사용자 정의 오류 구조가 바로 LSP 원리임
enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case invalidStatusCode
}

struct MockUserService {
    func fetchUser() async throws {
        do {
            throw APIError.invalidResponse // 오류를 발생시키려는 경우 다시 한번 하위 클래스가 기본 클래스 또는 상위 클래스를 대체할 수 있습니다. URLError(.badURL) 대신 사용 즉 전체적인 부모 Error 타입으로 동작 하는 곳에 자식을 넣어줘도 대체가 가능
        } catch {
            print("Error : \(error)")
        }
    }
}

let mockUserService = MockUserService()
Task{ try await mockUserService.fetchUser}




// MARK: - Interface Segregation Principle (ISP) 인터페이스 분리 원리
// 인터페이스를 일반화하여 구현하지 않는 인터페이스를 채택하는 것보다 구체적인 인터페이스를 채택하는 것이 더 좋다는 원칙

protocol GestureProtocol{
    func didTap()
    func didDoubleTap()
    func didLongPress()
}

// 개별 프로토콜로 나누어 우리가 준수 하는지 확인
protocol SingleTapProtocol {
    func didTap()
}

protocol DoubleTapProtocol {
    func didDoubleTap()
}

protocol LongPressProtocol {
    func didLongPress()
}

struct SuperButton: SingleTapProtocol, DoubleTapProtocol, LongPressProtocol {
    func didTap() {
        
    }
    
    func didDoubleTap() {
        
    }
    
    func didLongPress() {
        
    }
    
    
}

struct DoubleTapButton: DoubleTapProtocol {

    func didDoubleTap() {
        print("DEBUG: Double tap...")
    }
  
}

// 이렇게 하는것이 ISP 원칙을 준수하는 방법임





// MARK: - High-level Modules should not depend on low-level modules

protocol PaymentMethoed {
    func execute(amount: Double)
}


struct DebitCardPayMent: PaymentMethoed{
    func execute(amount: Double) {
        print("Debit card payment success for \(amount)")
    }
}

struct StripePayMent: PaymentMethoed {
    func execute(amount: Double) {
        print("Stripe payment success for \(amount)")
    }
}

struct ApplePayPayment: PaymentMethoed {
    func execute(amount: Double) {
        print("ApplePay payment success for \(amount)")
    }
}

struct PayMent {
    var debitCardPayment: DebitCardPayMent?
    var stripePayMent: StripePayMent?
    var applePayPayMent: ApplePayPayment?
}

let paymentMethod = DebitCardPayMent()
let payment = PayMent(debitCardPayment: paymentMethod, stripePayMent: nil, applePayPayMent: nil)
// 결제가 nil 이므로 이는 종속성 반전을 따르지 않음
// 너무 지저분해짐 확장성도 낮고 여러 하위 수준 모듈에 의존하는 상위 수준 모듈 문제가 있으므로 대신 추상화 담당자에 의존하고 싶기 때문에 다시 한번 구현하려고 합니다.
payment.debitCardPayment?.execute(amount: 100)
payment.stripePayMent?.execute(amount: 100)


struct PaymentDIP {
    let payment: PaymentMethoed
    
    func makePayMent(amount: Double) {
        payment.execute(amount: amount)
    }
}

let stripe = StripePayMent()
let paymentDIP = PaymentDIP(payment: stripe)

paymentDIP.makePayMent(amount: 200)
// 이것은 상위 모듈의 낮은 수준의 모듈 대신 추상화에 의존하는 훨씬 더 깔끔한 구현임
// 즉 상위 모듈이 하위 모듈에 의존하는것도 사라지고 두 모듈 모두 추상화에 의존

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    let dic = ["USD","GBP","EUR", "CAN"]
    
    init(amount am: Int, currency cu: String) {
        if dic.contains(cu) {
            amount = am
            currency = cu
        } else {
            amount = 0
            currency = "Unsupported"
            print("ERR: currency unsupported!")
        }
            
    }
    
    func convert(_ otherCu: String) -> Money {
        var new: Money
        var oldToUsd = 0.0
        let old = Double(self.amount)
        
        switch self.currency {
        case "USD":
            oldToUsd = old
        case "GBP":
            oldToUsd = old * 2
        case "EUR":
            oldToUsd = old / 1.5
        case "CAN":
            oldToUsd = old / 1.25
        default:
            break
        }
        
        switch otherCu {
        case self.currency:
            new = self
        case "USD":
            let newAmt = Int(oldToUsd)
            new = Money(amount: newAmt, currency: otherCu)
        case "GBP":
            let newAmt = Int((oldToUsd / 2).rounded())
            new = Money(amount: newAmt, currency: otherCu)
        case "EUR":
            let newAmt = Int((oldToUsd * 1.5).rounded())
            new = Money(amount: newAmt, currency: otherCu)
        case "CAN":
            let newAmt = Int((oldToUsd * 1.25).rounded())
            new = Money(amount: newAmt, currency: otherCu)
        default:
            new = Money(amount: 0, currency: "USD")
        }
        return new
    }
    
    public func add(_ otherM: Money) -> Money {
        let myM: Money = self.convert(otherM.currency)
        return Money(amount: myM.amount + otherM.amount, currency: otherM.currency)
    }
    
    public func subtract(_ otherM: Money) -> Money {
        let myM: Money = self.convert(otherM.currency)
        return Money(amount: otherM.amount - myM.amount, currency: otherM.currency)
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Salary(let s):
            return Int(s)
        case .Hourly(let h):
            return Int((h * Double(hours)).rounded())
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Salary(let salary):
            self.type = JobType.Salary(salary + UInt(byAmount.rounded()))
        case .Hourly(let hourly):
            self.type = JobType.Hourly(hourly + Double(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Salary(let salary):
            self.type = JobType.Salary(salary + UInt((Double(salary) * byPercent).rounded()))
        case .Hourly(let hourly):
            self.type = JobType.Hourly(hourly + (hourly * (byPercent)))
        }
    }
    
}

////////////////////////////////////
// Person
//
public class Person {
    
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if (age < 18) {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if (age < 18) {
                spouse = nil
            }
        }
    }
    
    init(firstName fn: String, lastName ln: String, age a: Int) {
        self.firstName = fn
        self.lastName = ln
        self.age = a
    }
    
    func toString() -> String {
        let hasJob: String = self.job?.title ?? "nil"
        let hasSpouse: String = self.spouse?.firstName ?? "nil"
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(hasJob) spouse:\(hasSpouse)]"
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    
    var members: [Person] = []
    
    init(spouse1 sp1: Person, spouse2 sp2: Person) {
        if (sp1.spouse == nil && sp2.spouse == nil) {
            sp1.spouse = sp2
            sp2.spouse = sp1
            members = [sp1, sp2]
        }
    }
    
    public func haveChild(_ child: Person) -> Bool {
        if members.count == 2 {
            if (members[0].age > 21 || members[1].age > 21) {
                members.append(child)
                return true
            }
        }

        return false
    }
    
    public func householdIncome() -> Int {
        var total = 0
        for p in members {
            if (p.job != nil) {
                total += p.job?.calculateIncome(2000) ?? 0
            }
        }
        return total
    }
    
}

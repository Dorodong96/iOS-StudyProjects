
protocol AdvancedLifeSupport {
    func performCPR()
}

class EmergencyCallHandler {
    // 프로토콜 채택, 자신을 delegate로 설정하는 누구든 AdvancedLifeSupport 업무를 수행하도록 함
    var delegate: AdvancedLifeSupport?
    
    func assessSituation() {
        print("Can you tell me what happened?")
    }
    
    func medicalEmergency() {
        // delegate로 설정된 누구든지 performCPR을 수행하도록 함
        delegate?.performCPR()
    }
}

struct Paramedic: AdvancedLifeSupport {
    
    init(handler: EmergencyCallHandler) {
        // 자신을 delegate로 설정
        handler.delegate = self
    }
    
    func performCPR() {
        print("The paramedic does chest compressions, 30 per second.")
    }
    
}

class Doctor: AdvancedLifeSupport {
    
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("The doctor does chest compressions, 30 per second.")
    }
    
    func useStethescope() {
        print("Listening for heart sounds")
    }
}

class Surgeon: Doctor {
    override func performCPR() {
        super.performCPR()
        print("Sings staying alive by the BeeGees")
    }
    
    func useElectricCrill() {
        print("Whirr...")
    }
}

let emilio = EmergencyCallHandler()
let pete = Paramedic(handler: emilio) // emilio가 응급 콜을 줄 것임
let angela = Surgeon(handler: emilio)

emilio.assessSituation()
emilio.medicalEmergency()

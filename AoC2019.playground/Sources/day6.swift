import Foundation

class OrbitalObject {
    let name: String
    var orbiting: OrbitalObject?

    init(name: String, orbiting: OrbitalObject?) {
        self.name = name
        self.orbiting = orbiting
    }

    var orbits: Int {
        guard let parent = orbiting else { return 0 }
        return parent.orbits + 1
    }
}

struct MapRecord {
    let parent: String
    let child: String
}

func orbitalChain(orbitalObject: OrbitalObject) -> [OrbitalObject] {
    var chain: [OrbitalObject] = [orbitalObject]
    var current = orbitalObject.orbiting
    while current != nil {
        chain.insert(current!, at: 0)
        current = current?.orbiting
    }
    return chain
}

public func day6() {
    guard let fileUrl = Bundle.main.url(forResource: "input6", withExtension: nil) else { fatalError() }
    guard let text = try? String(contentsOf: fileUrl, encoding: String.Encoding.utf8) else { fatalError() }
    let orbitalRecords: [MapRecord] = text.split(separator: "\n")
        .map({
            let bodies = $0.split(separator: ")")
            return MapRecord(parent: String(bodies[0]), child: String(bodies[1]))
        })

    var orbitalObjectsMap: [String: OrbitalObject] = [:]

    for record in orbitalRecords {
        let orbitalObjectParent = orbitalObjectsMap[record.parent] ?? OrbitalObject(name: record.parent, orbiting: nil)
        let orbitalObjectChild = orbitalObjectsMap[record.child] ?? OrbitalObject(name: record.child, orbiting: orbitalObjectParent)
        orbitalObjectChild.orbiting = orbitalObjectParent

        orbitalObjectsMap[orbitalObjectParent.name] = orbitalObjectParent
        orbitalObjectsMap[orbitalObjectChild.name] = orbitalObjectChild
    }

    print("Added \(orbitalObjectsMap.count) objects...")

    let totalOrbits = orbitalObjectsMap.values
        .map({ $0.orbits })
        .reduce(0) { (acc, current) -> Int in
            acc + current
        }

    print("There are \(totalOrbits) total direct and indirect orbits")

    let me = orbitalObjectsMap["YOU"]
    let meToCom = orbitalChain(orbitalObject: me!).map({ $0.name })
    var meToComOrbits = Set(meToCom)
    meToComOrbits.remove("YOU")


    let santa = orbitalObjectsMap["SAN"]
    let santaToCom = orbitalChain(orbitalObject: santa!).map({ $0.name })
    var santaToComOrbits = Set(santaToCom)
    santaToComOrbits.remove("SAN")

    let differences = santaToComOrbits.symmetricDifference(meToComOrbits)
    print("Minimum orbital jumps: \(differences.count)")
}

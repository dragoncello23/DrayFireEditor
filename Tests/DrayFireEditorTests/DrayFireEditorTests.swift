import XCTest
@testable import DrayFireEditor

final class DrayFireEditorTests: XCTestCase {

    override func setUpWithError() throws {
        // Configurazione iniziale del test: qui puoi aggiungere codice da eseguire prima di ogni test.
    }

    override func tearDownWithError() throws {
        // Pulizia finale del test: qui puoi aggiungere codice per rimuovere ogni configurazione dopo ogni test.
    }

    func testExample() throws {
        // Esempio di test di una funzionalità: puoi sostituirlo con un test specifico per la tua app.
        let valueToTest = true
        XCTAssertTrue(valueToTest, "Il valore dovrebbe essere true")
    }

    func testPerformanceExample() throws {
        // Esempio di test delle prestazioni: misura il tempo di esecuzione di codice specifico.
        self.measure {
            // Codice da misurare.
            let sum = (1...1000).reduce(0, +)
            XCTAssertEqual(sum, 500500, "La somma dovrebbe essere 500500")
        }
    }
}

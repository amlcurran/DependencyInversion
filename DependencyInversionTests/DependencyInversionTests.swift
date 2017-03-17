import XCTest
import Foundation

class DependencyInversionTests: XCTestCase {
    
	func testWhenAFruitHasNotBeenCached_ItIsDownloaded() {

	}

	func testWhenAFruitHasBeenCached_ItIsFetchedFromTheCache() {

	}
    
}

class CachingFruitFetcher {

	func fetchFruit(completion: (Fruit) -> Void) {
		if let name = UserDefaults.standard.string(forKey: "lastFruit") {
			completion(Fruit(name: name))
		} else {
			URLSessionFruitFetcher.instance.loadFruitFromInternet(completion: completion)
		}
	}

}

struct Fruit {
	let name: String
}

class URLSessionFruitFetcher {

	static let instance = URLSessionFruitFetcher()

	func loadFruitFromInternet(completion: (Fruit) -> Void) {
		// pretend this loads a fruit from some API
		completion(Fruit(name: "Kiwi"))
	}

}

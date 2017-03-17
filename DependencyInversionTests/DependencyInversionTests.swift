import XCTest
import Foundation

class DependencyInversionTests: XCTestCase {
    
	func testWhenAFruitHasNotBeenCached_ItIsDownloaded() {

	}

	func testWhenAFruitHasBeenCached_ItIsFetchedFromTheCache() {

	}

	func testWhenAFruitHasNotBeenCached_ButItFailsToDownload_TheCompletionBlockIsCalledWithNil() {

	}
    
}

// Here are the implementations

class CachingFruitFetcher {

	func fetchFruit() -> Fruit? {
		if let name = UserDefaults.standard.string(forKey: "lastFruit") {
			return Fruit(name: name)
		} else {
			return URLSessionFruitFetcher.instance.loadFruitFromInternet()
		}
	}

}

struct Fruit {
	let name: String
}

class URLSessionFruitFetcher {

	static let instance = URLSessionFruitFetcher()

	func loadFruitFromInternet() -> Fruit? {
		// pretend this loads a fruit from some API
		return Fruit(name: "Kiwi")
	}

}

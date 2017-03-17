import XCTest
import Foundation

class DependencyInversionTests: XCTestCase {
    
	func testWhenAFruitHasNotBeenCached_ItIsLoadedFromTheInternet() {
		let fetcher = CachingFruitFetcher()

		let fruit = fetcher.fetchFruit(cache: EmptyCache(), internet: WorkingInternet())

		XCTAssertEqual(fruit?.name, "Turkey")
	}

	func testWhenAFruitHasBeenCached_ItIsLoadedFromTheCache() {
		let fetcher = CachingFruitFetcher()

		let fruit = fetcher.fetchFruit(cache: FullCache(), internet: WorkingInternet())

		XCTAssertEqual(fruit?.name, "Grapes")
	}

	func testWhenAFruitHasNotBeenCached_ButLoadingFromTheInternetFails_NoFruitIsReturned() {
		let fetcher = CachingFruitFetcher()

		let fruit = fetcher.fetchFruit(cache: EmptyCache(), internet: FailingInternet())

		XCTAssertNil(fruit)
	}
    
}

// Here are the implementations

class CachingFruitFetcher {

	func fetchFruit(cache: Cache = UserDefaultsCache(),
	                internet: Internet = InternetFruitFetcher()) -> Fruit? {
		if let name = cache.lastFruitName {
			return Fruit(name: name)
		} else {
			return try? internet.loadFruitFromInternet()
		}
	}

}

// Protocols

protocol Cache {
	var lastFruitName: String? { get }
}

protocol Internet {
	func loadFruitFromInternet() throws -> Fruit
}

// Test implementations


class FailingInternet: Internet {

	func loadFruitFromInternet() throws -> Fruit {
		throw NSError(domain: "", code: 0, userInfo: nil)
	}

}

class FullCache: Cache {

	var lastFruitName: String? {
		return "Grapes"
	}

}

class EmptyCache: Cache {

	var lastFruitName: String? {
		return nil
	}
	
}

class WorkingInternet: Internet {

	func loadFruitFromInternet() throws -> Fruit {
		return Fruit(name: "Turkey")
	}

}

// Implementations to use in real life

class UserDefaultsCache: Cache {

	var lastFruitName: String? {
		return UserDefaults.standard.string(forKey: "lastFruit")
	}

}

class InternetFruitFetcher: Internet {

	static let instance = InternetFruitFetcher()

	func loadFruitFromInternet() throws -> Fruit {
		// pretend this loads a fruit from some API
		return Fruit(name: randomFruitName())
	}
	
}

struct Fruit {
	let name: String
}

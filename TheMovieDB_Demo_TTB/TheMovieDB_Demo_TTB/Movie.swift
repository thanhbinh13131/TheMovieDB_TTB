//
//  Movie.swift
//  TheMovieDB_Demo_TTB
//
//  Created by TTB on 5/20/17.
//  Copyright © 2017 TTB. All rights reserved.
//

import Foundation

class Movie {
    
    private var title: String
    private var overview: String
    private var dateRelease: String
    private var posterPath: String
    
    init(title: String,overview: String, dateRelease: String, posterPath: String) {
        self.title = title
        self.overview = overview
        self.dateRelease = dateRelease
        self.posterPath = posterPath
    }
    
    func getTitle() -> String{
        return title
    }
    func getOverview() -> String{
        return overview
    }
    func getDateRelease() -> String{
        return dateRelease
    }
    func getPosterPath() -> String{
        return posterPath
    }
}

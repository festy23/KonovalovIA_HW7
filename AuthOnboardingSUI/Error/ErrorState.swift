//
//  ErrorState.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

enum ErrorState
{
    case Error(message: String)
    case Success(message: String)
    case None // no error state
}

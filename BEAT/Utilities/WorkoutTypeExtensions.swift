//
//  WorkoutTypeExtensions.swift
//  InsSense
//
//  Created by Controllab on 4/24/26.
//

import HealthKit

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        // MARK: Individual Sports
        case .archery:                      return "archery"
        case .bowling:                      return "bowling"
        case .fencing:                      return "fencing"
        case .gymnastics:                   return "gymnastics"
        case .trackAndField:                return "track and field"
 
        // MARK: Team Sports
        case .americanFootball:             return "american football"
        case .australianFootball:           return "australian football"
        case .baseball:                     return "baseball"
        case .basketball:                   return "basketball"
        case .cricket:                      return "cricket"
        case .discSports:                   return "disc sports"
        case .handball:                     return "handball"
        case .hockey:                       return "hockey"
        case .lacrosse:                     return "lacrosse"
        case .rugby:                        return "rugby"
        case .soccer:                       return "soccer"
        case .softball:                     return "softball"
        case .volleyball:                   return "volleyball"
 
        // MARK: Exercise and Fitness
        case .mixedMetabolicCardioTraining: return "mixed cardio"
        case .preparationAndRecovery:       return "preparation and recovery"
        case .flexibility:                  return "flexibility"
        case .cooldown:                     return "cooldown"
        case .walking:                      return "walk"
        case .running:                      return "run"
        case .wheelchairWalkPace:           return "weelchair walk"
        case .wheelchairRunPace:            return "wheelchair run"
        case .cycling:                      return "cycling"
        case .handCycling:                  return "hand cycling"
        case .coreTraining:                 return "core training"
        case .elliptical:                   return "elliptical"
        case .functionalStrengthTraining:   return "functional strength training"
        case .traditionalStrengthTraining:  return "traditional strength training"
        case .crossTraining:                return "cross training"
        case .mixedCardio:                  return "mixed cardio"
        case .highIntensityIntervalTraining: return "high intensity interval training"
        case .jumpRope:                     return "jump rope"
        case .stairClimbing:                return "stair stepper"
        case .stairs:                       return "stairs"
        case .stepTraining:                 return "step training"
        case .fitnessGaming:                return "fitness gaming"
 
        // MARK: Studio Activities
        case .dance:                        return "dance"
        case .danceInspiredTraining:        return "dance"
        case .barre:                        return "barre"
        case .cardioDance:                  return "cardio dance"
        case .socialDance:                  return "social dance"
        case .yoga:                         return "yoga"
        case .mindAndBody:                  return "mind and body"
        case .pilates:                      return "pilates"
 
        // MARK: Racket Sports
        case .badminton:                    return "badminton"
        case .pickleball:                   return "pickleball"
        case .racquetball:                  return "racquetball"
        case .squash:                       return "squash"
        case .tableTennis:                  return "table tennis"
        case .tennis:                       return "tennis"
 
        // MARK: Outdoor Activities
        case .climbing:                     return "climbing"
        case .equestrianSports:             return "equestrian sports"
        case .fishing:                      return "fishing"
        case .golf:                         return "golf"
        case .hiking:                       return "hiking"
        case .hunting:                      return "hunting"
        case .play:                         return "play"
 
        // MARK: Snow and Ice Sports
        case .crossCountrySkiing:           return "skiing crosscountry"
        case .curling:                      return "curling"
        case .downhillSkiing:               return "skiing downhill"
        case .snowSports:                   return "snowboarding"
        case .snowboarding:                 return "snowboarding"
        case .skatingSports:                return "skating"
 
        // MARK: Water Activities
        case .paddleSports:                 return "paddling"
        case .rowing:                       return "rowing"
        case .sailing:                      return "sailing"
        case .surfingSports:                return "surfing"
        case .swimming:                     return "swimming"
        case .underwaterDiving:             return "underwater diving"
        case .waterFitness:                 return "water fitness"
        case .waterPolo:                    return "water polo"
        case .waterSports:                  return "water sports"
 
        // MARK: Martial Arts
        case .boxing:                       return "boxing"
        case .kickboxing:                   return "kickboxing"
        case .martialArts:                  return "martial arts"
        case .taiChi:                       return "taichi"
        case .wrestling:                    return "wrestling"
            
        // MARK: MultiSport Activities
        case .swimBikeRun:                  return "swim bike run"
        case .transition:                   return "transition"
            
        // MARK: Other
        case .other:                        return "other"
 
        // Fallback for any future cases Apple adds
        @unknown default:                   return "unkown"
        }
    }
    
    
    var systemImageName: String {
        switch self {
        // MARK: Individual Sports
        case .archery:                      return "target"
        case .bowling:                      return "figure.bowling"
        case .fencing:                      return "figure.fencing"
        case .gymnastics:                   return "figure.gymnastics"
        case .trackAndField:                return "figure.track.and.field"
 
        // MARK: Team Sports
        case .americanFootball:             return "figure.american.football"
        case .australianFootball:           return "figure.australian.football"
        case .baseball:                     return "figure.baseball"
        case .basketball:                   return "figure.basketball"
        case .cricket:                      return "figure.cricket"
        case .discSports:                   return "figure.disc.sports"
        case .handball:                     return "figure.handball"
        case .hockey:                       return "figure.hockey"
        case .lacrosse:                     return "figure.lacrosse"
        case .rugby:                        return "figure.rugby"
        case .soccer:                       return "figure.soccer"
        case .softball:                     return "figure.softball"
        case .volleyball:                   return "figure.volleyball"
 
        // MARK: Exercise and Fitness
        case .mixedMetabolicCardioTraining: return "figure.mixedCardio"
        case .preparationAndRecovery:       return "figure.cooldown"
        case .flexibility:                  return "figure.flexibility"
        case .cooldown:                     return "figure.cooldown"
        case .walking:                      return "figure.walk"
        case .running:                      return "figure.run"
        case .wheelchairWalkPace:           return "figure.roll"
        case .wheelchairRunPace:            return "figure.roll.runningpace"
        case .cycling:                      return "figure.outdoor.cycle"
        case .handCycling:                  return "figure.hand.cycling"
        case .coreTraining:                 return "figure.core.training"
        case .elliptical:                   return "figure.elliptical"
        case .functionalStrengthTraining:   return "figure.strengthtraining.functional"
        case .traditionalStrengthTraining:  return "figure.strengthtraining.traditional"
        case .crossTraining:                return "figure.cross.training"
        case .mixedCardio:                  return "figure.mixed.cardio"
        case .highIntensityIntervalTraining: return "figure.highintensity.intervaltraining"
        case .jumpRope:                     return "figure.jumprope"
        case .stairClimbing:                return "figure.stair.stepper"
        case .stairs:                       return "figure.stairs"
        case .stepTraining:                 return "figure.step.training"
        case .fitnessGaming:                return "gamecontroller.fill"
 
        // MARK: Studio Activities
        case .dance:                        return "figure.dance"
        case .danceInspiredTraining:        return "figure.dance"
        case .barre:                        return "figure.barre"
        case .cardioDance:                  return "figure.dance"
        case .socialDance:                  return "figure.socialdance"
        case .yoga:                         return "figure.yoga"
        case .mindAndBody:                  return "figure.mind.and.body"
        case .pilates:                      return "figure.pilates"
 
        // MARK: Racket Sports
        case .badminton:                    return "figure.badminton"
        case .pickleball:                   return "figure.pickleball"
        case .racquetball:                  return "figure.racquetball"
        case .squash:                       return "figure.squash"
        case .tableTennis:                  return "figure.table.tennis"
        case .tennis:                       return "figure.tennis"
 
        // MARK: Outdoor Activities
        case .climbing:                     return "figure.climbing"
        case .equestrianSports:             return "figure.equestrian.sports"
        case .fishing:                      return "figure.fishing"
        case .golf:                         return "figure.golf"
        case .hiking:                       return "figure.hiking"
        case .hunting:                      return "figure.hunting"
        case .play:                         return "figure.play"
 
        // MARK: Snow and Ice Sports
        case .crossCountrySkiing:           return "figure.skiing.crosscountry"
        case .curling:                      return "figure.curling"
        case .downhillSkiing:               return "figure.skiing.downhill"
        case .snowSports:                   return "figure.snowboarding"
        case .snowboarding:                 return "figure.snowboarding"
        case .skatingSports:                return "figure.skating"
 
        // MARK: Water Activities
        case .paddleSports:                 return "figure.water.fitness"
        case .rowing:                       return "figure.rowing"
        case .sailing:                      return "sailboat.fill"
        case .surfingSports:                return "figure.surfing"
        case .swimming:                     return "figure.pool.swim"
        case .underwaterDiving:             return "figure.open.water.swim"
        case .waterFitness:                 return "figure.water.fitness"
        case .waterPolo:                    return "figure.water.polo"
        case .waterSports:                  return "figure.water.fitness"
 
        // MARK: Martial Arts
        case .boxing:                       return "figure.boxing"
        case .kickboxing:                   return "figure.kickboxing"
        case .martialArts:                  return "figure.martial.arts"
        case .taiChi:                       return "figure.taichi"
        case .wrestling:                    return "figure.wrestling"
            
        // MARK: MultiSport Activities
        case .swimBikeRun:                  return "figure.mixed.cardio"
        case .transition:                   return "figure.mixed.cardio"
            
        // MARK: Other
        case .other:                        return "figure.mixed.cardio"
 
        // Fallback for any future cases Apple adds
        @unknown default:                   return "figure.run.circle"
        }
    }
}

import UIKit

var greeting = "Hello, playground"



// Örnek veri kümesi
let courses = CourseManager.fetchLessonsFromAPI()

// Dersleri grupla
let organizedCourses = CourseManager.groupCoursesByYearAndType(courses: courses)

// Sonucu kontrol et
print(organizedCourses)

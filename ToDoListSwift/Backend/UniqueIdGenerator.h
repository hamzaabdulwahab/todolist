//
//  UniqueIdGenerator.h
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

#ifndef UniqueIdGenerator_h
#define UniqueIdGenerator_h


#include <string>

class UniqueIdGenerator {
public:
    static int generateId() {
        int counter = 0;
        return (counter++);
    }
};

#endif /* UniqueIdGenerator_h */

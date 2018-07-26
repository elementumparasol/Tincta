//
//  CSVStructure.h
//  Tincta AppStore
//
//  Created by tombp on 24/07/2018.
//

#import <Foundation/Foundation.h>

typedef struct EachCell{
    int row_holder;
    int row_pos;
    int col_pos;
    int visible;
    
    char cell_text[1000];
    struct EachCell *p_up;
    struct EachCell *p_down;
    struct EachCell *p_left;
    struct EachCell *p_right;
} EachCell;

class IA_CSV{
public:
    EachCell *p_csv;
    
public:
    IA_CSV();
    ~IA_CSV();
    void PrintAllNodes();
    void update_PCSV_From_String(NSString* m_str);
    void get_CSV_Format_String(char* &m_str);
};





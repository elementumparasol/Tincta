//
//  CSVStructure.m
//  Tincta AppStore
//
//  Created by tombp on 24/07/2018.
//

#import "CSVStructure.h"

IA_CSV::IA_CSV()
{
    p_csv = NULL;
}

IA_CSV::~IA_CSV()
{
    EachCell *p_next_row;
    EachCell *p_next_col;
    EachCell *p_tmp_col;
    p_next_row = p_csv;
    while(p_next_row != NULL) {
        p_next_col = p_next_row;
        p_next_row = p_next_row->p_down;
        while (p_next_col != NULL) {
            p_tmp_col = p_next_col;
            p_next_col = p_next_col->p_right;
            delete p_tmp_col;
        }
    }
}
void IA_CSV::PrintAllNodes()
{
    EachCell *p_next_row;
    EachCell *p_next_col;
    EachCell *p_tmp_col;
    p_next_row = p_csv;
    while(p_next_row != NULL) {
        p_next_col = p_next_row;
        p_next_row = p_next_row->p_down;
        while (p_next_col != NULL) {
            p_tmp_col = p_next_col;
            p_next_col = p_next_col->p_right;
            printf("(Current[%d,%d],L[%d,%d],U[%d,%d],R[%d,%d],D[%d,%d])\r\n",p_tmp_col->row_pos,p_tmp_col->col_pos,p_tmp_col->p_left!=NULL?p_tmp_col->p_left->row_pos:-1,p_tmp_col->p_left!=NULL?p_tmp_col->p_left->col_pos:-1,p_tmp_col->p_up!=NULL?p_tmp_col->p_up->row_pos:-1,p_tmp_col->p_up!=NULL?p_tmp_col->p_up->col_pos:-1,p_tmp_col->p_right!=NULL?p_tmp_col->p_right->row_pos:-1,p_tmp_col->p_right!=NULL?p_tmp_col->p_right->col_pos:-1,p_tmp_col->p_down!=NULL?p_tmp_col->p_down->row_pos:-1,p_tmp_col->p_down!=NULL?p_tmp_col->p_down->col_pos:-1) ;
        }
    }
    
}
void get_CSV_row_col_Text(NSString *str_csv_p,int row,int col,char* c_str_out)
{
    NSString *str_csv = [NSString stringWithFormat:@"%@\r\n",str_csv_p];
    if ([str_csv length] <= 1 ){
        return ;
    }
    int row_index = 0, row_start = -1 , row_end = -1;
    int p = 0;
    int len = [str_csv length];
    
    
    
    while (p < len ) {
        unichar m_char = [str_csv characterAtIndex:p];
        if (m_char == '\n') {
            row_index++;
            if (row_index > row ) {
                row_end = p - 1;
                p = row_end;
                break;
            }
        }
        p++;
    }
    while (p != 0) {
        unichar m_char = [str_csv characterAtIndex:p];
        if (m_char == '\n') {
            row_start = p;
            break;
        }
        p--;
    }
    if (row_start == -1) {
        row_start = 0;
    }
    NSString *str_tmp = [str_csv substringWithRange:NSMakeRange(row_start, row_end-row_start)];
    NSString *str_sub = [NSString stringWithFormat:@",%@,",str_tmp];
//    char *test_ee = (char*)[str_sub UTF8String];
//    len = strlen(test_ee);
//    memset(c_str_out, 0, len+1);
//    memcpy(c_str_out, test_ee, len);
    
    if ([str_sub length] <= 2) {
        return;
    }
    row_index = 0;
    row_start = -1 ;
    row_end = -1;
    p = 0;
    len = [str_sub length];
    while (p < len ) {
        unichar m_char = [str_sub characterAtIndex:p];
        if (m_char == ',') {
            row_index++;
            if (row_index-1 > col ) {
                row_end = p - 1;
                p = row_end;
                break;
            }
        }
        p++;
    }
    while (p >= 0) {
        unichar m_char = [str_sub characterAtIndex:p];
        if (m_char == ',') {
            row_start = p+1;
            break;
        }
        p--;
    }
    NSString *str_sub_sub_tmp = [str_sub substringWithRange:NSMakeRange(row_start, row_end-row_start+1)];
    NSString *str_sub_sub = [str_sub_sub_tmp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    char *test_ee = (char*)[str_sub_sub UTF8String];
        len = strlen(test_ee);
        memset(c_str_out, 0, len+1);
        memcpy(c_str_out, test_ee, len);
}




void get_CSV_row_col(char *c_csv,int *row,int *col)
{
    if (strlen(c_csv)==0) {
        *row = -1;
        *col = -1;
        return ;
    }
    int m_row = 1;
    int m_col = 0;
    char *p = c_csv;
    while( *p != 0){
        if (*p == '\n') {
            m_row++;
        }
        if (*p == ',') {
            m_col++;
        }
        p++;
    }
    m_col = m_col/m_row;
    *row = m_row;
    *col = m_col+1;
}
void IA_CSV::get_CSV_Format_String(char * &m_str)
{
    NSMutableString *m_text = [[NSMutableString alloc] init];
    EachCell *p_next_row;
    EachCell *p_next_col;
    EachCell *p_tmp_col;
    int n_row_max = 1;
    int n_col_max = 1;
    p_next_row = p_csv;
    if (p_next_row == NULL) {
        return;
    }
    while (p_next_row->p_down != NULL) {
        n_row_max++;
        p_next_row = p_next_row->p_down;
    }
    p_next_row = p_csv;
    while (p_next_row->p_right != NULL) {
        n_col_max++;
        p_next_row = p_next_row->p_right;
    }
    int *p_col_width_max = new int[n_col_max];
    int tmp;
    p_next_row = p_csv;
    for (int i = 0; i < n_col_max; i++) {
        p_next_row = p_csv;
        for (int j = 0; j < i; j++) {
            p_next_row = p_next_row->p_right;
        }
        tmp = 0;
        int j = 0 ;
        while (p_next_row!= NULL) {
            if (strlen(p_next_row->cell_text)>tmp) {
                tmp = strlen(p_next_row->cell_text);
            }
            NSLog(@"[%d,%d]->%s",i,j,p_next_row->cell_text);
            p_next_row = p_next_row->p_down;
            j++;
        }
        p_col_width_max[i] = tmp;
    }
    p_next_row = p_csv;
    while(p_next_row != NULL) {
        p_next_col = p_next_row;
        p_next_row = p_next_row->p_down;
        int j = 0;
        NSString *str_tmp;
        while (p_next_col != NULL) {
            p_tmp_col = p_next_col;
            p_next_col = p_next_col->p_right;
//            delete p_tmp_col;
            str_tmp = [NSString stringWithUTF8String:p_tmp_col->cell_text];
            [m_text appendString:str_tmp];
            for (int i = 5 + p_col_width_max[j] - [str_tmp length]; i > 0; i--) {
                [m_text appendString:@" "];
            }
            j++;
        }
        [m_text appendString:@"\r\n"];
    }
    char *p_temp = (char*)[m_text UTF8String];
    int str_len = strlen(p_temp);
    m_str = new char[str_len+1];
    memset(m_str, 0, str_len+1);
    memcpy(m_str, p_temp, str_len);
}

void IA_CSV::update_PCSV_From_String(NSString* m_str)
{
    EachCell *p_next_row;
    EachCell *p_next_col;
    EachCell *p_tmp_col;
    p_next_row = p_csv;
    while(p_next_row != NULL) {
        p_next_col = p_next_row;
        p_next_row = p_next_row->p_down;
        while (p_next_col != NULL) {
            p_tmp_col = p_next_col;
            p_next_col = p_next_col->p_right;
            delete p_tmp_col;
        }
    }
    const char *tmp_str = [m_str UTF8String];
    int tmp_str_len = strlen(tmp_str);
    char *c_csv = (char*)malloc(tmp_str_len+1);
    memset(c_csv, 0, tmp_str_len+1);
    memcpy(c_csv, [m_str UTF8String] , tmp_str_len);
    int row = 0 ,col = 0;
    get_CSV_row_col(c_csv, &row, &col);
    char test[1000];
    get_CSV_row_col_Text(m_str, 0, 1, test);
    free(c_csv);
    NSString *str_get = [NSString stringWithUTF8String:test];
    
    EachCell *p_header = NULL ;
    EachCell *p_each = NULL ;
    EachCell *p_row_up = NULL;
    EachCell *p_col_left = NULL ;
    int str_len = 0;
    for(int i = 0 ;i < row;i++){
        for(int j = 0;j < col;j++){
            get_CSV_row_col_Text(m_str, i, j, test);
            NSLog(@"test[%d][%d][%s]",i,j,test);
            str_len = strlen(test);
            p_each = new EachCell;
            p_each->p_up = NULL;
            p_each->p_down = NULL;
            p_each->p_left = NULL;
            p_each->p_right = NULL;
            p_each->visible = 1;
            p_each->row_pos = i;
            p_each->col_pos = j;
            memset(p_each->cell_text,0,sizeof(p_each->cell_text));
            if (strlen(test) > 0) {
                memcpy(p_each->cell_text, test, strlen(test));
            }
            if (p_header == NULL) {
                p_header = p_each;
            }
            p_each->p_up = p_row_up;
            p_each->p_left = p_col_left;
            if (p_row_up != NULL) {
                p_row_up->p_down = p_each;
                p_each->p_up = p_row_up;
            }
            if (p_col_left != NULL) {
                p_col_left->p_right = p_each;
                p_each->p_left = p_col_left;
            }
            p_col_left = p_each;
            if (p_row_up != NULL && p_row_up->p_right != NULL ) {
                p_row_up = p_row_up->p_right;
            }
        }
        p_col_left = NULL;
        if (p_row_up != NULL) {
            while (p_row_up->p_left != NULL) {
                p_row_up = p_row_up->p_left;
            }
            p_row_up = p_row_up->p_down;
        }else{
            p_row_up = p_header;
        }
    }
    p_csv = p_header;
    PrintAllNodes();
    NSLog(@"Test");
}

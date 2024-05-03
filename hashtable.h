#ifndef HASHTABLE_H
#define HASHTABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
  INT,
  STRING,
} ValueType;

struct Entry {
  char *key;
  void *value;
  ValueType type;
  struct Entry *next;
};

struct HashTable {
  unsigned int size;
  struct Entry *entries;
};

unsigned int hashFunction(char *str);
struct HashTable *createHashTable(int size);
void add(struct HashTable *table, char *key, void *value, ValueType type);
void printHashTable(struct HashTable *table);
struct Entry *search(struct HashTable *table, char *key);
void *createIntValue(int num);
void *createStringValue(char *str);

#endif /* HASHTABLE_H */

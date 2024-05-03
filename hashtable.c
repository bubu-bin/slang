#include "hashtable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int hashFunction(char *str) {
  unsigned int hash = 0;

  while (*str) {
    hash += (unsigned char)(*str);
    str++;
  }

  return hash;
}

struct HashTable *createHashTable(int size) {
  struct HashTable *table = malloc(sizeof(struct HashTable));

  table->size = size;
  table->entries = malloc(sizeof(struct Entry) * size);

  for (int i = 0; i < size; i++) {
    table->entries[i].key = NULL;
    table->entries[i].value = NULL;
    table->entries[i].next = NULL;
  }

  return table;
}

void printHashTable(struct HashTable *table) {
  if (table == NULL) {
    return;
  }

  printf("%-10s%-10s%-20s%-10s%s\n", "INDEX", "LIST_POS", "KEY", "TYPE",
         "VALUE");

  for (int i = 0; i < table->size; i++) {
    struct Entry *entry = &table->entries[i];

    if (entry->key == NULL) {
      printf("%-10d%-10s%-20s%-10s%s\n", i, "EMPTY", "", "", "");
      continue;
    }

    int listPos = 0;
    while (entry != NULL) {
      printf("%-10d%-10d%-20s", i, listPos, entry->key);

      switch (entry->type) {
      case STRING:
        printf("%-10s%s\n", "STRING", (char *)entry->value);
        break;
      case INT:
        printf("%-10s%d\n", "INT", *(int *)entry->value);
        break;
      default:
        printf("%-10s%s\n", "UNKNOWN", "");
        break;
      }

      entry = entry->next;
      listPos++;
    }
  }
}

void add(struct HashTable *table, char *key, void *value, ValueType type) {
  if (table == NULL) {
    return;
  }

  unsigned int index = hashFunction(key) % table->size;

  struct Entry *entry = &table->entries[index];

  // First entry at this index
  if (entry->key == NULL) {
    entry->key = strdup(key);
    entry->value = value;
    entry->type = type;

    return;
  }

  // Handle collisions with chaining
  while (entry != NULL) {
    // Update existing value
    if (strcmp(entry->key, key) == 0) {
      entry->value = value;
      return;
    }

    if (entry->next == NULL) {
      break;
    }

    entry = entry->next;
  }

  // Add new entry at the end of the chain
  struct Entry *newEntry = malloc(sizeof(struct Entry));

  if (newEntry == NULL) {
    perror("Failed to malloc new entry");
    return;
  }

  newEntry->key = strdup(key);
  newEntry->value = value;
  newEntry->next = NULL;
  newEntry->type = type;

  entry->next = newEntry;
}

struct Entry *search(struct HashTable *table, char *key) {
  if (table == NULL) {
    return NULL;
  }

  unsigned int index = hashFunction(key) % table->size;
  struct Entry *entry = &table->entries[index];

  while (entry != NULL) {
    if (strcmp(entry->key, key) == 0) {
      return entry;
    }

    entry = entry->next;
  }

  return NULL;
}

void *createIntValue(int num) {
  int *ptr = (int *)malloc(sizeof(int));

  if (ptr == NULL) {
    perror("Failed to malloc int value");
    return NULL;
  }

  *((int *)ptr) = num;
  return ptr;
}

void *createStringValue(char *str) {
  if (str == NULL) {
    return NULL;
  }

  char *copy = strdup(str);

  if (copy == NULL) {
    perror("Failed to malloc string value");
    return NULL;
  }

  return copy;
}

// int main() {
// struct HashTable *table = createHashTable(11);

// add(table, "key1", createIntValue(123), INT);
// add(table, "key2", createIntValue(312), INT);
// add(table, "key5", createStringValue("somevalue"), STRING);

// printHashTable(table);

// return 0;
// }

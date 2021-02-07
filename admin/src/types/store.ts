export interface RecordBase {
  id: string;
  type: string;
}

export interface Attributes {
  [key: string]: any;
}

export interface RelationShips {
  [model: string]: {
    data: RecordBase | RecordBase[];
  };
}

export interface Record extends RecordBase {
  attributes: Attributes;
  relationships: RelationShips;
}

export interface User extends Record {
  attributes: {
    email: string;
    created_at: string;
    updated_at: string;
  };
}

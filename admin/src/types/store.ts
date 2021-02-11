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

export interface Session {
  id: string;
  email: string;
  provider: string;
  uid: string;
  allow_password_change: string;
}

export interface Record extends RecordBase {
  attributes: Attributes;
  relationships?: RelationShips;
}

export interface Setting extends Record {
  attributes: {
    site_title: string;
    mail_to: string;
    main_cover_url: string;
    anable_main_cover: string;
    anable_recent_comments: string;
    anable_recent_popular: string;
    recent_popular_span: string;
    updated_at: string;
  };
}

export interface User extends Record {
  attributes: {
    email: string;
    created_at: string;
    updated_at: string;
  };
}

export interface Profile extends Record {
  attributes: {
    user_id: string;
    name: string;
    description: string;
    avatar_url: string;
    created_at: string;
    updated_at: string;
  };
}

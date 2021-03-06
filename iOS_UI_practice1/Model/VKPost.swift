//
//  VKPost.swift
//  iOS_UI_practice1
//
//  Created by Alexey on 25/02/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit

// Типы постов
enum PostType: String {
    case post
    case wall_photo
    case photo
//    case photo_tag
//    case friend
//    case note
    case audio
    case video
    case mixed
}

enum PostMediaType {
    case none
    case singlePhoto
    case gif
    case singleVideo
    case collection
}

// Типы вложений в пост
enum AttachmentType: String {
    case photo
    case link
    case audio
    case video
}

struct VKPost {
    let type: PostType
    let postId: Int
    let sourceId: Int // если положительный - новость пользователя, отрицательный - новость группы
    let date: Date
    let text: String? // текст поста
    let mediaType: PostMediaType // тип визуального наполнения поста (фото, видео, коллекция, гиф)
    
    var photos: [VKPhoto]
    var attachments: [VKAttachment]
    
    var likes: VKLike
    var comments: Int
    var reposts: Int
    var views: Int
    
    // вычисляемые параметры
    var textHeight: CGFloat = 0
    var showFullText: Bool = false
    var hasBigText: Bool = false
    
    // сохранять юзера или группу, которым принадлежит пост
    let byUser: VKUser?
    let byGroup: VKGroup?
}

struct PostsArray {
    var items: [VKPost]
    var profiles: [VKUser]
    var groups: [VKGroup]
}

struct NewsResponse {
    var response: PostsArray
}

struct VKLink {
    let url: String
    let title: String
    let descr: String
    let target: String // пока строка, но нужен enum
}

// Базовый класс для аттачмента новости
class VKAttachment {
    let type: AttachmentType
    
    init(type: AttachmentType) {
        self.type = type
    }
}

// Аттачмент типа "ссылка"
class VKNewsLink: VKAttachment {
    let link: VKLink
    
    init(type: AttachmentType, url: String, title: String, description: String, target: String) {
        self.link = VKLink(url: url, title: title, descr: description, target: target)
        super.init(type: type)
    }
}

// Аттачмент типа "видео"
class VKNewsVideo: VKAttachment {
    let video: VKVideo
    
    init(type: AttachmentType, title: String, description: String, video: VKVideo) {
        self.video = video
        super.init(type: type)
    }
}

// Аттачмент типа "фото"
//class VKNewsPhoto: VKAttachment {
//    let photo: VKPhoto
//    
//    init(type: AttachmentType, id: Int, albumID: Int, userID: Int?, imageSizes: [VKImage], text: String) {
//        self.photo = VKPhoto(id: id, albumID: albumID, userID: userID, imageSizes: imageSizes, text: text)
//        super.init(type: type)
//    }
//}

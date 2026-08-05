//
//  QuickLayout.swift
//  LayoutFrameworkBenchmark
//
//  Created by James Randolph on 8/4/26.
//

import UIKit
import QuickLayout

@QuickLayout
class QuickLayoutView: UIView, DataBinder {
    
    var body: QuickLayout::Layout {
        QuickLayout::VStack(alignment: .leading) {
            QuickLayout::HStack {
                actionLabel
                QuickLayout::Spacer()
                optionsLabel
            }
            QuickLayout::HStack(spacing: 2) {
                posterImageView
                QuickLayout::VStack(alignment: .leading, spacing: 1) {
                    posterNameLabel
                    posterHeadlineLabel
                    posterTimeLabel
                }
                QuickLayout::Spacer()
            }
            posterCommentLabel
            QuickLayout::HStack {
                QuickLayout::Spacer()
                contentImageView
                QuickLayout::Spacer()
            }
            contentTitleLabel
            contentDomainLabel
            QuickLayout::HStack {
                likeLabel
                QuickLayout::Spacer()
                commentLabel
                QuickLayout::Spacer()
                shareLabel
            }
            QuickLayout::HStack {
                actorImageView
                actorCommentLabel
                QuickLayout::Spacer()
            }
        }
    }

    let actionLabel = UILabel()

    let optionsLabel: UILabel = {
        let l = UILabel()
        l.text = "..."
        return l
    }()

    let posterImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        i.backgroundColor = UIColor.orange
        i.contentMode = .scaleToFill
        return i
    }()

    let posterNameLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor.yellow
        return l
    }()

    let posterHeadlineLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor.yellow
        return l
    }()

    let posterTimeLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor.yellow
        return l
    }()

    let posterCommentLabel = UILabel()

    let contentImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "350x200.png")
        i.contentMode = .scaleToFill
        return i
    }()

    let contentTitleLabel = UILabel()
    let contentDomainLabel = UILabel()

    let likeLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .green
        l.text = "Like"
        return l
    }()

    let commentLabel: UILabel = {
        let l = UILabel()
        l.text = "Comment"
        l.backgroundColor = .green
        l.textAlignment = .center
        return l
    }()

    let shareLabel: UILabel = {
        let l = UILabel()
        l.text = "Share"
        l.backgroundColor = .green
        l.textAlignment = .right
        return l
    }()

    let actorImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "50x50.png")
        return i
    }()

    let actorCommentLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: FeedItemData) {
        actionLabel.text = data.actionText
        posterNameLabel.text = data.posterName
        posterHeadlineLabel.text = data.posterHeadline
        posterTimeLabel.text = data.posterTimestamp
        posterCommentLabel.text = data.posterComment
        contentTitleLabel.text = data.contentTitle
        contentDomainLabel.text = data.contentDomain
        actorCommentLabel.text = data.actorComment
    }
}
